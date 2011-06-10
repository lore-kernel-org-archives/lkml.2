Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1FJJeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:34:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33637 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1FJJeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:34:05 -0400
Date: Fri, 10 Jun 2011 11:33:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-ID: <20110610093354.GH27280@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.493181962@chello.nl>
 <20110609130617.f8aca966.akpm@linux-foundation.org>
 <20110609202707.GA28951@elte.hu>
 <1307652883.2497.1028.camel@laptop>
 <20110609140714.fc9ea187.akpm@linux-foundation.org>
 <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
 <20110609170804.1b76e853.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609170804.1b76e853.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Some notes:
> 
> Stupid thing doesn't explain the magical locking though :( I'm 
> 99.9% sure that putting an up() inside a spinlock_irq()ed region 
> was deliberate.

My guess would be it's done so that pending irqs that have queued up 
during our current printk-ing activities do not hit us with the 
console still locked.

Thanks,

	Ingo
