Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1EDRMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:12:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:43846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1EDRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:12:44 -0400
Date: Wed, 4 May 2011 19:12:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504165021.GA1404@elte.hu>
Message-ID: <alpine.LFD.2.02.1105041908220.3005@ionos>
References: <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos>
 <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <20110504165021.GA1404@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > My gut reaction would be: let's do the minimal patch that just fixes things 
> > to do irqsafe_cpu_cmpxchg_double() for 2.6.39, and then let's remove the 
> > #ifdef'fery in -rc1. [...]
> 
> Looks like the sanest option IMHO, -rc7 is pretty late for anything than a 
> few-liner patch.

Agreed.
 
> > [...] Or make _really_ sure that things are ok for platforms that never even 
> > triggered the CMPXCHG_LOCAL case before.
> 
> Considering that the status quo was !CMPXCHG_LOCAL in v2.6.38 and that lockless 
> SLUB is an x86-only affair right now:
> 
>  $ git grep CMPXCHG_LOCAL arch/
>  arch/um/Kconfig.x86:config CMPXCHG_LOCAL
>  arch/x86/Kconfig.cpu:config CMPXCHG_LOCAL
> 
> There should be no problem with other architectures, right?

No, they use the local_irq disabled path which is pretty much the same
as in 38.

Thanks,

	tglx
