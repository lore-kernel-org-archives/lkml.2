Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1EDKNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:13:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44020 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab1EDKNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:13:38 -0400
Date: Wed, 4 May 2011 12:13:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504101327.GA847@elte.hu>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504083559.GB25724@elte.hu>
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

> I've built a CONFIG_DEBUG_PAGEALLOC=y and CONFIG_SLUB_DEBUG=y kernel, maybe the 
> crash triggers in a more revealing way.

After an hour of testing it still has not triggered. This could have multiple 
reasons:

 - Maybe i reproduced the original crash by pure luck.

   To exclude this i'll re-test once again with the non-debug .config.

 - There's some kernel image layout dependency that twiddling these options has
   hidden.

   This is the lowest probability explanation, because the problem
   triggered for me after tweaking the original .config and using a different
   toolchain.

 - These debug options could have narrowed the race window and could make the
   race much less likely to occur.

   This is the highest probability explanation.

Thanks,

	Ingo
