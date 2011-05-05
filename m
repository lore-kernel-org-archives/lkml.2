Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1EEW1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:27:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:34715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1EEW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:27:43 -0400
Date: Fri, 6 May 2011 00:27:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: werner <w.landgraf@ru.ru>
cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <web-518814410@zbackend1.aha.ru>
Message-ID: <alpine.LFD.2.02.1105052329440.3005@ionos>
References: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com> <alpine.DEB.2.00.1105041454190.5495@router.home> <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com> <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com> <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org> <web-518794926@zbackend1.aha.ru> <alpine.DEB.2.00.1105051504250.8529@router.home> <web-518814410@zbackend1.aha.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, werner wrote:
> 90% of the config options, users don't know for what they are.  Instead of
> more and more new config features in, EVERY CONFIG PARAMETER WHAT THE KERNEL
> CAN DETECT AT RUN TIME (at the beginning of booting) SHOULD BE THROWED OUT.
> And the kernel should be compiled 'everythingyes' as default.   Even then,
> with all exotic (but nowadays happening) boot-necessary input/output hardware
> included, my vmlinuz is only 10 MB big.   Sufficient memory for run this
> (together with an initrd for an installer) nowadays should exist on almost all
> computers.  All other, not-boot necessary modules are perhaps 50 MB, and since
> the Atari time with 20 MB harddisks passed, there is NO REASON FOR COMPILE
> SMALL THE KERNEL. Even on Android phones, compiling the kernel / modules 50 MB
> big but using often only a part, dont hurt. But for emergency, instead of
> completely configless, one could let 2 options for the kernel config:  normal,
> small (below 16 M memory).   Provisorically, one could but one should not
> include such a raw-selection menu in the kernel config, because to check and
> maintain the dependences of their various single config parameters would be
> big extra work.   Instead of this, one should rigorously make more and more
> config parameters definitively obsolete and reduce them by improving the
> corresponding runtime ability of the kernel.

Have a look outside of the x86 and "smartphone brag with your GBs of
RAM" world and you'll see that there are 

  - systems which really care about size reductions which are measured
    in kilobytes.

  - systems where runtime detection is impossible

  - systems where runtime detection is complete overkill in various
    aspects: boottime, memory footprint ...  

And you CANNOT put those requirements under a single CONFIG_VERY_SMALL=y
fits it all thing simply because embedded devices have those fundamental
different requirements vs. drivers, filesystems ....

Aside of that config options are a pretty useful mechanism to debug
problems.

And in the context of that particular case you are barking up the
completely wrong tree. The facts that

 - slub used the wrong macro

 - the CONFIG dependent x86 implementation of that this_cpu_* mess was
   crap to begin with

are not an argument at all to go and impose a 100MB/50MB/16MB or
whatever arbitrary choice you make limit of CONFIG_FITS_IT_ALL_*
approach.

That simply does not work.

Thanks,

	tglx
