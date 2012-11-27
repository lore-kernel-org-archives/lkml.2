Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2K0MYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:24:50 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:53691 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab2K0MYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:24:48 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Date: Tue, 27 Nov 2012 14:24:45 +0200
User-Agent: KMail/1.9.10
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
In-Reply-To: <201211271348.14603.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201211271424.45588.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, I've found that warning while working on the older kernel with 
older gcc (ver. 3.4.4). The modern gcc (ver. 4.5.4) does not emit that 
warning no matter how hard I try. For example, it does not warn even with the 
following line in the drivers/uio/Makefile:

  ccflags-$(CONFIG_UIO) += -O2 -Wall -Wextra -Wuninitialized

In that case the actual command line looks like (from "make V=1" output):

gcc -Wp,-MD,drivers/uio/.uio.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/4.5.4/include -I/home/vitas/Progs/net-next/net-next/arch/x86/include -Iarch/x86/include/generated  -Iinclude -I/home/vitas/Progs/net-next/net-next/arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I/home/vitas/Progs/net-next/net-next/include/uapi -Iinclude/generated/uapi -include /home/vitas/Progs/net-next/net-next/include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_AVX=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO -O2 -Wall -Wextra -Wuninitialized    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(uio)"  -D"KBUILD_MODNAME=KBUILD_STR(uio)" -c -o 
drivers/uio/uio.o drivers/uio/uio.c

I wander why doesn't modern gcc warn about obvious use of uninitialized 
variable. Is it some known regression in gcc?

-- 
With Best Regards,
Vitalii Demianets
