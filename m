Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1EDSUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:20:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab1EDSUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home>
 <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home>
 <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 11:20:22 -0700
Message-ID: <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 8:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll take it. I'm just hoping to also get Werner's tested-by for it.
>
> I'm pretty confident this is it, though, so if I don't get it by the
> end of the day I'll just apply it regardless with just a reported-by
> from him.

So I'm still waiting for the tested-by, but in the meantime I wrote a
changelog. And part of that changelog reads:

[ Btw, that whole "generic code defaults to no protection" design just
  sounds stupid - if the code needs no protection, there is no reason to
  use "cmpxchg_double" to begin with.  So we should probably just remove
  the unprotected version entirely as pointless.   - Linus ]

which really sums up the whole thing.

The current "this_cpu_cmpxchg_double()" implementation is just
incredibly idiotic. There is absolutely _no_ point to having that
function at all. Why does it exist?

I can kind of see the point of the "preempt" version, although I'm not
entirely convinced of that either. But the notion of having a
"cmpxchg" function that isn't atomic even on a single CPU just makes
me go "f*ck that, whoever wrote that is just a moron".

If the function doesn't need atomicity, you're really better off just
writing it out.  It's going to be faster on pretty much all
architectures using just regular load/store instructions.

                   Linus
