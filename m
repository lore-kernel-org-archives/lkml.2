Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab2DUFB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 01:01:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48305 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2DUFB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 01:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <1334958476-6296-1-git-send-email-msalter@redhat.com>
References: <1334958476-6296-1-git-send-email-msalter@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 21 Apr 2012 01:01:04 -0400
Message-ID: <CAMjpGUe+CMkHP7owZym_6c2RDvgLzj8t+ZpLBuqQ0euk+ArV2Q@mail.gmail.com>
Subject: Re: [PATCH] C6X: add support to build with BINFMT_ELF_FDPIC
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 17:47, Mark Salter wrote:
> --- a/arch/c6x/kernel/process.c
> +++ b/arch/c6x/kernel/process.c
>
> +
> +/* Fill in the fpu structure for a core dump. This is easy -- we don't have any */
> +int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
> +{
> +       /* Not valid */
> +       return 0;
> +}

you could avoid this like Blackfin has:
arch/blackfin/include/asm/elf.h:
#define ELF_CORE_COPY_FPREGS(...) 0     /* Blackfin has no FPU */

> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
>
>  config BINFMT_ELF_FDPIC
>        bool "Kernel support for FDPIC ELF binaries"
>        default y
> -       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU))
> +       depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || TMS320C6X)

shouldn't the main arch symbol be "C6X" to match arch/c6x/ ?
-mike
