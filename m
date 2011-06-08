Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1FHUxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:53:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38102 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab1FHUxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:53:17 -0400
Date: Wed, 8 Jun 2011 22:52:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110608205253.GA10669@elte.hu>
References: <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <4DED0292.1040605@die-jansens.de>
 <4DED0423.4050904@die-jansens.de>
 <20110606170725.GD2391@elte.hu>
 <1307380311.2322.223.camel@twins>
 <1307548218.3941.6.camel@twins>
 <20110608191758.GA12457@elte.hu>
 <1307562329.3941.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307562329.3941.21.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2011-06-08 at 21:17 +0200, Ingo Molnar wrote:
> > Hm, the no-wakeup aspect seems rather useful.
> > 
> > Could we perhaps remove console_sem and replace it with a mutex and 
> > do something like this with a mutex and its ->wait_lock?
> > 
> > We'd have two happy side effects:
> > 
> >  - we'd thus remove one of the last core kernel semaphore users
> >  - we'd gain lockdep coverage for console locking as a bonus ... 
> 
> The mutex thing is more complex due to the mutex fast path, the 
> advantage of the semaphore is its simple implementation that always 
> takes the internal lock.
> 
> I guess I can make it happen, but its a tad more tricky.

Hm, i thought it would be possible to only express it via the 
slowpath: if mutex_trylock() succeeds then *all* execution goes into 
the slowpath so we don't have to take all the fastpaths into account.

If that's notpossible then i think you and Linus are right that it's 
not worth creating all the per arch fastpath special cases for 
something like this.

The non-removal of the console_sem is sad though. Sniff.

Thanks,

	Ingo
