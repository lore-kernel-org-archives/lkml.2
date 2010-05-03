Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0ECINW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 04:13:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55958 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0ECINU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 04:13:20 -0400
Date: Mon, 3 May 2010 10:13:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
Message-ID: <20100503081313.GA7111@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Tom Zanussi <tzanussi@gmail.com>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
 <20100503062407.GB15241@elte.hu>
 <4BDE6D5A.6060407@zytor.com>
 <20100503065416.GD15241@elte.hu>
 <20100503073749.GA1694@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100503073749.GA1694@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, May 03, 2010 at 09:37:49AM +0200

> It broke half of the non-x86 architectures. For example on Sparc defconfig:
> 
> In file included from /home/mingo/tip/include/asm-generic/bitops/hweight.h:4,
>                  from /home/mingo/tip/arch/sparc/include/asm/bitops_32.h:103,
>                  from /home/mingo/tip/arch/sparc/include/asm/bitops.h:6,
>                  from /home/mingo/tip/include/linux/bitops.h:17,
>                  from /home/mingo/tip/include/linux/kernel.h:15,
>                  from /home/mingo/tip/include/linux/sched.h:54,
>                  from /home/mingo/tip/arch/sparc/kernel/asm-offsets.c:13:
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight32':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:8: error: implicit declaration of function '__sw_hweight32'
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight16':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:13: error: implicit declaration of function '__sw_hweight16'
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight8':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:18: error: implicit declaration of function '__sw_hweight8'
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight64':
> /home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:23: error: implicit declaration of function '__sw_hweight64'
> 
> (the failure on other architectures looks similar)

Looks like we're missing the __sw_hweightXX prototype definitions in
that include maze. Ingo, which -tip branch is that and can you put it
somewhere for me to test?

Thanks.

-- 
Regards/Gruss,
    Boris.
