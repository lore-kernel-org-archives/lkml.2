Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1EDPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:41:58 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:50624 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1EDPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:41:57 -0400
Date: Wed, 4 May 2011 18:41:50 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Christoph Lameter <cl@linux.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <alpine.DEB.2.00.1105040958570.5495@router.home>
Message-ID: <alpine.DEB.2.00.1105041840410.4479@tiger>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Christoph Lameter wrote:
> Subject: slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery
>
> Remove the #ifdefs. This means that the irqsafe_cpu_cmpxchg_double() is used
> everywhere.
>
> There may be performance implications since:
>
> A. We now have to manage a transaction ID for all arches
>
> B. The interrupt holdoff for arches not supporting CONFIG_CMPXCHG_LOCAL is reduced
> to a very short irqoff section.
>
> There are no multiple irqoff/irqon sequences as a result of this change. Even in the fallback
> case we only have to do one disable and enable like before.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

This doesn't apply cleanly on top of slab/next which has some of your 
cleanup patches applied. There's some CONFIG_PREEMPT conflicts so I'd 
rather you rediffed it yourself.

 			Pekka
