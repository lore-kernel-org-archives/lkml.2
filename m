Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1FFPwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:52:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab1FFPwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:52:53 -0400
Date: Mon, 6 Jun 2011 17:52:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606155236.GA7374@elte.hu>
References: <4DEB6F3A.3000109@die-jansens.de>
 <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
 <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <1307349530.2353.7374.camel@twins>
 <20110606145827.GD30348@elte.hu>
 <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307375227.2322.161.camel@twins>
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

> Needs more staring at, preferably by someone who actually 
> understands that horrid mess :/ Also, this all still doesn't make 
> printk() work reliably while holding rq->lock.

So, what about my suggestion to just *remove* the wakeup from there 
and use the deferred wakeup mechanism that klogd uses.

That would make printk() *visibly* more robust in practice.

[ It would also open up the way to possibly make printk() NMI entry 
  safe - currently we lock up if we printk in an NMI or #MC context 
  that happens to nest inside a printk(). ]

Thanks,

	Ingo
