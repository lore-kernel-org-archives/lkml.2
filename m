Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1EDPOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:14:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab1EDPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:14:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105040958570.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 08:13:44 -0700
Message-ID: <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 8:00 AM, Christoph Lameter <cl@linux.com> wrote:
>
> Right there is only the tid management that is added. Hope I am fast
> enough to at least get one patch in (not very well tested):

So the thing that worries me about this is non-x86 architectures.

Have we verified that the generic routines are ok for all
architectures? Has somebody checked the memory barriers in particular?
Things that work on x86 may not work on non-x86. Everything should be
per-cpu _except_ for the initialization, I think, but that should be
double-checked.

I guess the initialization happens so early that we don't really need
to worry about it, but I'd still like somebody to really double- and
triple-check it for me.

My gut reaction would be: let's do the minimal patch that just fixes
things to do irqsafe_cpu_cmpxchg_double() for 2.6.39, and then let's
remove the #ifdef'fery in -rc1. Or make _really_ sure that things are
ok for platforms that never even triggered the CMPXCHG_LOCAL case
before.

Hmm?

                        Linus
