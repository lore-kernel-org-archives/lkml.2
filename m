Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0FWHXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:23:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0FWHXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:23:23 -0400
Subject: Re: [patch 11/33] fs: dcache scale subdirs
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1277258596.1685.16.camel@localhost>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.609317663@nick.local0.net>
	 <1276787615.27822.426.camel@twins> <20100617165329.GA6138@laptop>
	 <1277127322.1875.516.camel@laptop> <20100621144806.GC31679@laptop>
	 <1277132103.1875.519.camel@laptop> <1277186557.1791.7.camel@work-vm>
	 <1277191631.1875.525.camel@laptop>  <1277258596.1685.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Jun 2010 09:23:15 +0200
Message-ID: <1277277795.1875.748.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 19:03 -0700, john stultz wrote:

> > Well, you make lockdep very unhappy by locking multiple dentries
> > (unbounded number) all in the same lock class.
> 
> So.. Is there a way to tell lockdep that the nesting is ok (I thought
> that was what the spin_lock_nested call was doing...)? 

spin_lock_nested() allows you to nest a limited number of locks (up to
8, although the usual case is 1).

> Or is locking a (possibly quite long) chain of objects really just a
> do-not-do type of operation? 

Usually, yeah. It would be really nice to do this another way (also for
scalability, keeping a large subtree locked is bound to to lead to more
contention).
