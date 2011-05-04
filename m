Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1EDQIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:08:40 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:46822 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751610Ab1EDQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:08:39 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: kzEudxgVM1kPuac1mDoZyb_pWfcNiO55FPaW9dT4AUJE1zZ
 .tfldAMHSgc2uZ1fZPkJ5L9EvSuSGvs3.snYWdE5uH3Epvc7rUVbMMUvgpRZ
 X4Q817GmvlzEXIzEjastniygsXJh69tlzHobhpiFlsqzqU8Aqw3ZT0JRCfHE
 Re2kTfZD.kUTOrVe0.PzmH3VZzECpODffASFrDSlvuLqbFIpwEYqnMrCRd82
 4KrvlgI7sOR6jKJ0X7czzU.eqrAtd_2vpP6HIo5zhNszPIqXiUNarXLozvGF
 i0xoiDY6PQan7tB8U5xejC8zDb0hMYtS.__rU7Q0NqIF90Avn
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 11:08:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <BANLkTi=XDYVyveGR6fh73kiOp=A2eH8b7A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105041052390.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home> <BANLkTi=XDYVyveGR6fh73kiOp=A2eH8b7A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Linus Torvalds wrote:

> On Wed, May 4, 2011 at 8:28 AM, Christoph Lameter <cl@linux.com> wrote:
> >
> > There are no memory barriers used. The barrier() here is a compiler hint
> > to not keep data across it.
>
> Go back and read my email, please.
>
> The lack of memory barriers is exactly what I worry about.
>
> Look at the initialization path. The "tid" thing is _not_ purely cpu-local.

kmem_cache_create() only hands the pointer to the slab cache back
after the percpu values have been initialized. In order to do an allocation one
needs to have the pointer to the slab cache.

You think that accesses to struct kmem_cache_cpu by other cpus could
require memory barriers? But this is what both SLAB and SLUB already do
today even before these modification. Nor do we have memory barriers for
the same situation in the page allocator.




