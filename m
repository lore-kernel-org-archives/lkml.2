Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1EDTps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:45:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab1EDTpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105041421280.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home>
 <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home>
 <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 12:38:28 -0700
Message-ID: <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 12:30 PM, Christoph Lameter <cl@linux.com> wrote:
>
> The naming convention came about from the existing this_cpu_xxx
> operations

You're missing my point.

An "add" operation makes sense even if it isn't atomic, because
atomicity isn't a part of the definition of "add".

But cmpxchg DOES NOT MAKE SENSE without atomicity guarantees.

The whole operation is about atomicity.

Having a version that isn't atomic is STUPID. It's misleading. It's _wrong_.

In contrast, having a non-atomic "add" version is understandable.

So when  you say "naming convention", you're missing the much bigger
naming convention. Namely the "cmpxchg" part!

                           Linus
