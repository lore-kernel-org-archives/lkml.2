Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1EDVlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:41:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:46135 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1EDVlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:41:02 -0400
Date: Wed, 4 May 2011 23:40:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105042325500.3005@ionos>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home> <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home> <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
 <alpine.DEB.2.00.1105041454190.5495@router.home> <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com> <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Linus Torvalds wrote:

> On Wed, May 4, 2011 at 2:06 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The problem is that cmpxchg *IS*NOT*AN*CMPXCHG*AT*ALL*. Not even on UP.
> 
> Btw, the really sad thing is that as far as I can tell, the
> cmpxchg64_local() function that we define actually gets this *right*,
> with a helper function that actually works (and disables interrupts)
> and all the alternative_io() stuff to then use the right instruction
> automatically if the CPU supports it, rather than making it a
> hardcoded decision.
> 
> But we don't use it, because the "percpu_cmpxchg8b_double()" code
> rolls its own inferior version, and has slightly different semantics
> (ie the whole "return value success" thing).

Yeah, I tripped over that as well. And the new shiny extra
CONFIG_CMPXCHG_DOUBLE misfeature Christoph nailed together is just
ignoring it as well. It's just more useless #ifdef and CONFIG bloat.

That whole this_cpu_* stuff seems to be designed by committee. A quick
grep shows that max. 10% of the implemented macro hell is actually
used. Can we get rid of all unused ones and bring them back when they
are actually required?

Thanks,

	tglx
