Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1EDQuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:50:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52071 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1EDQuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:50:39 -0400
Date: Wed, 4 May 2011 18:50:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504165021.GA1404@elte.hu>
References: <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
 <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos>
 <20110504142532.GC17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041640020.3005@ionos>
 <alpine.DEB.2.00.1105040958570.5495@router.home>
 <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> My gut reaction would be: let's do the minimal patch that just fixes things 
> to do irqsafe_cpu_cmpxchg_double() for 2.6.39, and then let's remove the 
> #ifdef'fery in -rc1. [...]

Looks like the sanest option IMHO, -rc7 is pretty late for anything than a 
few-liner patch.

> [...] Or make _really_ sure that things are ok for platforms that never even 
> triggered the CMPXCHG_LOCAL case before.

Considering that the status quo was !CMPXCHG_LOCAL in v2.6.38 and that lockless 
SLUB is an x86-only affair right now:

 $ git grep CMPXCHG_LOCAL arch/
 arch/um/Kconfig.x86:config CMPXCHG_LOCAL
 arch/x86/Kconfig.cpu:config CMPXCHG_LOCAL

There should be no problem with other architectures, right?

Thanks,

	Ingo
