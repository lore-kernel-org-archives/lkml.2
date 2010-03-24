Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0CXQha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:37:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:34551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0CXQh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:37:29 -0400
Subject: Re: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "holt@sgi.com" <holt@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <1269447146.2881.0.camel@sbs-t61.sc.intel.com>
References: <ff8c11be-b22d-4849-9b19-d9107c4fea47@email.android.com>
	 <1268871558.2696.60.camel@sbs-t61.fm.intel.com>
	 <1269430347.5109.164.camel@twins>
	 <1269447146.2881.0.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 17:36:59 +0100
Message-ID: <1269448619.5109.443.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 09:12 -0700, Suresh Siddha wrote:
> On Wed, 2010-03-24 at 04:32 -0700, Peter Zijlstra wrote:
> > On Wed, 2010-03-17 at 16:19 -0800, Suresh Siddha wrote:
> > > On Wed, 2010-03-17 at 12:51 -0700, H. Peter Anvin wrote:
> > > > Well, as you know :) tglx and I are on the road ... I'll try to get to it on Friday before I take off again.
> > > 
> > > Also I talked to Thomas about this rwlock conversion and he referred to
> > > RT issues with rwlock. And the best is to avoid this using RCU.
> > 
> > Its not just RT, even for mainline rwlock_t is a massive pain and often
> > is no better (actually worse) than a spinlock due to the massive
> > cacheline bouncing it introduces.
> 
> Don't we have the same cacheline bouncing issues with the ticket
> spinlocks?

Sure, but the rwlock_t is unfair and can degrade into much worse
performance than the spinlock.

Thing is, rwlock_t needs to write to the cacheline for each read
acquire, so unless the hold time is much-much longer than the cacheline
bounce time, its just not worth it, but since its a rwlock_t it should
be have short hold time, hence its a useless construct :-)


