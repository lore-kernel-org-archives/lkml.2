Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1EDUt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:49:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1EDUtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:49:55 -0400
Date: Wed, 4 May 2011 22:49:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504204936.GA18594@elte.hu>
References: <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com>
 <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
 <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
 <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
 <alpine.DEB.2.00.1105041454190.5495@router.home>
 <19422.1304540499@localhost>
 <alpine.DEB.2.00.1105041530210.5495@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105041530210.5495@router.home>
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

> > Calling it a cmpxchg when it doesn't have the primary distinguishing 
> > property of a hardware cmpxchg is just loading a bullet in the chamber and 
> > inviting kernel hackers to point it at their feet...
> 
> It does have most of the distinguishing characterstics but the 
> lock-prefixless cmpxchg8b/16b (which is quite fast) [...]

6 cycles for CMPXCHG8B versus 19 cycles for LOCK CMPXCHG8B, on Nehalem.

And note that it's not really true that the LOCK prefix-less CMPXCHG8B is not 
atomic: the write is atomic if the target word is naturally aligned, on i586 
and upwards ...

So in practice, unless the SLUB variables are misaligned, the lock prefix-less 
CMPXCHG8B *IS* atomic.

Non-atomicity is a special case of a weird special case.

> [...] is used in a unique way here in a percpu fastdpath. Thats why we have 
> the strange naming this_cpu_cmpxchg_double etc.

Furthermore, we never used cmpxchg in the kernel without expecting atomicity.

Uniquely strange, unintuitive naming == invitation for strange bugs.

And guess what, we had a strange bug here. Can you possibly see any connection?

Thanks,

	Ingo
