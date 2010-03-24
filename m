Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0CXLcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:32:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab0CXLcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:32:54 -0400
Subject: Re: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "holt@sgi.com" <holt@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <1268871558.2696.60.camel@sbs-t61.fm.intel.com>
References: <ff8c11be-b22d-4849-9b19-d9107c4fea47@email.android.com>
	 <1268871558.2696.60.camel@sbs-t61.fm.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 12:32:27 +0100
Message-ID: <1269430347.5109.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 16:19 -0800, Suresh Siddha wrote:
> On Wed, 2010-03-17 at 12:51 -0700, H. Peter Anvin wrote:
> > Well, as you know :) tglx and I are on the road ... I'll try to get to it on Friday before I take off again.
> 
> Also I talked to Thomas about this rwlock conversion and he referred to
> RT issues with rwlock. And the best is to avoid this using RCU.

Its not just RT, even for mainline rwlock_t is a massive pain and often
is no better (actually worse) than a spinlock due to the massive
cacheline bouncing it introduces.


