Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1FEPcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:32:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36663 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1FEPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:32:40 -0400
Date: Sun, 5 Jun 2011 17:32:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605153218.GA31471@elte.hu>
References: <20110605110132.GB23463@elte.hu>
 <20110605111933.GA24592@elte.hu>
 <20110605113627.GA25724@elte.hu>
 <4DEB6F3A.3000109@die-jansens.de>
 <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
 <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <20110605152641.GA31124@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605152641.GA31124@elte.hu>
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


one more thing, could you please add this call:

	debug_show_all_locks();

to after the WARN(), in watchdog.c?

Please surround the whole printout portion by the 
spin_lock()/unlock() protection code i suggested, full-lock-state 
printouts are slow and other CPUs might start printing their NMI 
ticks ...

With the all-locks-printed output we can double check what locks are 
held.

Thanks,

	Ingo
