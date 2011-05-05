Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1EETOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:14:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab1EETOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:14:18 -0400
Date: Thu, 5 May 2011 21:13:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110505191353.GB23311@elte.hu>
References: <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
 <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
 <alpine.DEB.2.00.1105041454190.5495@router.home>
 <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com>
 <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com>
 <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org>
 <alpine.DEB.2.00.1105051319230.6821@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105051319230.6821@router.home>
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

> On Thu, 5 May 2011, Tejun Heo wrote:
> 
> > Anyways, that's what I've been thinking.  I'll get to it in the next
> > devel cycle or the one after that.  What do you guys think about soft
> > irq masking idea?
> 
> Great idea. Would make the whole irq on/off business much cheaper.

The tradeoffs are *not at all* clear and the result (on x86) is not
'much cheaper', at all ...

In particular the irq-enable path gets complicated by the need to check the 
flag and call a hardirq handling function in that case - a far cry from the 
single-byte POPF instruction. It will be somewhat cheaper cycle-wise - but the 
code gets bloated, so the instruction cache impact has to be measured 
carefully. (See my other mail for details.)

There's also the fact that PUSHF+CLI+POPF sequence has been getting cheaper all 
the time with newer hardware generations. CLI+STI is even cheaper, 10 cycles 
both on Intel and AMD CPUs. So it's an optimization that might get narrower and 
narrower with every CPU generation.

Thanks,

	Ingo
