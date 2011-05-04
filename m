Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1EDPVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:21:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab1EDPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:21:15 -0400
Date: Wed, 4 May 2011 17:20:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504152054.GA23210@elte.hu>
References: <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
 <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos>
 <20110504142532.GC17294@htj.dyndns.org>
 <alpine.DEB.2.00.1105040934570.5495@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105040934570.5495@router.home>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 4 May 2011, Tejun Heo wrote:
> 
> > The cmpxchg_double optimization made the fast path go quite faster
> > when CPU supports it but it may as well slow things down considerably
> > if CPU doesn't, due to extra irq on/off's.  Anyways, here's hoping
> > that the slow down is acceptable compared to the base code without
> > cmpxchg_double and the ugliness can be removed.
> 
> I think we are all in agreement. First path to fix the percpu macros:
> 
> 
> Subject: percpu: Fix irqsafe_cpu_cmpxchg_double
> 
> The function in the macro was not updated when the function was given a bool return value.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Note, the final commit needs to have a proper Reported-by and explanation about 
how this was triggered, to fairly credit all the hard work done by Werner ...

Thanks,

	Ingo
