Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1FELgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 07:36:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab1FELgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 07:36:42 -0400
Date: Sun, 5 Jun 2011 13:36:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605113627.GA25724@elte.hu>
References: <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
 <1307092535.2353.2973.camel@twins>
 <4DE8B13D.9020302@die-jansens.de>
 <1307097052.2353.3061.camel@twins>
 <20110605081747.GA17920@elte.hu>
 <4DEB4FA7.3050400@die-jansens.de>
 <20110605095555.GA22058@elte.hu>
 <4DEB58D8.4000805@die-jansens.de>
 <20110605110132.GB23463@elte.hu>
 <20110605111933.GA24592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605111933.GA24592@elte.hu>
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

> > If the ticks stop this suggests a lockup within the printk code. 
> > [...]
> 
> In which case the printk-killswitch patch below (to be applied 
> *instead* of the previous debugging patch i sent) should provide 
> the desired NMI watchdog output on the serial console.
> 
> Warning: it's entirely untested.

Note, since this is an SMP box, if the lockup messages show up with 
this patch but are mixed up with each other then adding a spinlock 
around the WARN() would probably help keeping the output serialized.

A simple:

 static DEFINE_SPINLOCK(watchdog_output_lock);

 ...
	spin_lock(&watchdog_output_lock);
 ...
	[ the WARN_ON() logic. ]
 ...
	spin_unlock(&watchdog_output_lock);
 ...

would suffice.

Thanks,

	Ingo
