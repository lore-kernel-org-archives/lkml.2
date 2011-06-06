Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab1FFPI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:08:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1FFPIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:08:24 -0400
Date: Mon, 6 Jun 2011 17:08:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606150808.GF30348@elte.hu>
References: <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
 <20110605172052.GA1036@elte.hu>
 <4DEBBFF9.2030101@die-jansens.de>
 <20110605185957.GA3452@elte.hu>
 <4DEBD95B.6030901@die-jansens.de>
 <20110605194419.GA12965@elte.hu>
 <4DEBE3DF.70104@die-jansens.de>
 <1307350909.2353.7408.camel@twins>
 <20110606150409.GE30348@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606150409.GE30348@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> The real fix might be to remove the lockdep_off()/on() call from 
> printk(), that looks actively evil ... we had to hack through 
> several layers of side-effects before we found the real bug - so 
> it's not like the off()/on() made things more robust!

The other obvious fix would be to *remove* the blasted wakeup from 
printk(). It's a serious debugging robustness violation and it's not 
like the wakeup is super important latency-wise.

We *already* have a timer tick driven klogd wakeup poll routine. So i 
doubt we'd have many problems from not doing wakeups from printk(). 
Opinions?

Thanks,

	Ingo
