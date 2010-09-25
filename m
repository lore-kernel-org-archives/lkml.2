Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0IYAUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:20:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0IYAUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:20:22 -0400
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20100923133103.GA3832@osiris.boeblingen.de.ibm.com>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
	 <4C98D0EB.30002@kernel.org> <1285083618.2275.884.camel@laptop>
	 <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
	 <1285147362.2275.896.camel@laptop> <1285165776.2275.1022.camel@laptop>
	 <20100923133103.GA3832@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 25 Sep 2010 02:19:47 +0200
Message-ID: <1285373987.2275.1048.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 15:31 +0200, Heiko Carstens wrote:
> On Wed, Sep 22, 2010 at 04:29:36PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-09-22 at 11:22 +0200, Peter Zijlstra wrote:
> > 
> > > The idea was to move it to a class of its own above SCHED_FIFO.
> > > 
> > > I'll try and get something done, but I'm heading out to LinuxCon.JP
> > > soon.
> > 
> > Something like the below, it seems to boot, build a kernel and hotplug.
> 
> Thanks for the fast patch. Yes, it works. Sort of:
> 
> ------------[ cut here ]------------

<SPLAT>

> 
> ..and crashes afterwards ;)

Yeah, I can imagine,. weird though, kthread_create() should leave the
new thread in uninterruptible context. The above warning implies this is
not so.. 

> Btw. I also tried to boot 2.6.35.5 with your patch and it hangs just at
> the beginning. I also had to apply 5e3d20a68f63fc5a310687d81956c3b96e488b84
> "init: Remove the BKL from startup code" to make the machine boot again,
> which was a bit surprising.

Most curious and unexpected,.. I'll try and have a look, but it might
have to wait until after LinuxCon.JP..


