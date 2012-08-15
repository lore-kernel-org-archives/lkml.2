Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2HON4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:56:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2HON4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:56:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 08/31] arm64: CPU support
Date: Wed, 15 Aug 2012 13:56:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-9-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151356.05416.arnd@arndb.de>
X-Provags-ID: V02:K0:eURON+FoDP7bbrdFNqX4VUGsE5VvlgWoHrMfZuk5N3b
 +AGDvNsts+RoWtI1qmRMS/39sk8edndRLFtvZQxd5XWHNNWjew
 l1m1WFTbxELyl0LP1PBev310hP7ABg6u1X2Lcv28JGo73Zlo67
 1auQiqcozFRtPyoiRM6twaO2QKffPQLZDia86IAsBytmTEMuj2
 SzAG67MdGH89RThBO4I6K86FMWLG1G/B/jsuy6WAshzqS5DtUc
 Bw5IXHVk3QSR6+X5GS6bA68kXJ9lbhjsR/ePExUiumaznDphw6
 mXzTjlq2RvuZB5O6+8MeDGim18nsPVCA2A5aNcbohwCW+lccA0
 IcnPPxzUhpkw/RpN5R5I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> diff --git a/arch/arm64/include/asm/procinfo.h b/arch/arm64/include/asm/procinfo.h
> new file mode 100644
> index 0000000..81fece9
> --- /dev/null
> +++ b/arch/arm64/include/asm/procinfo.h
> @@ -0,0 +1,44 @@
> +/*
> + * Based on arch/arm/include/asm/procinfo.h
> + *
> + * Copyright (C) 1996-1999 Russell King
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_PROCINFO_H
> +#define __ASM_PROCINFO_H
> +
> +#ifdef __KERNEL__
> +
> +/*
> + * Note!  struct processor is always defined if we're
> + * using MULTI_CPU, otherwise this entry is unused,
> + * but still exists.
> + *
> + * NOTE! The following structure is defined by assembly
> + * language, NOT C code.  For more information, check:
> + *  arch/arm/mm/proc-*.S and arch/arm/kernel/head.S
> + */
> +struct proc_info_list {
> +	unsigned int		cpu_val;
> +	unsigned int		cpu_mask;
> +	unsigned long		__cpu_flush;		/* used by head.S */
> +	const char		*cpu_name;
> +};
> +
> +#else	/* __KERNEL__ */
> +#include <asm/elf.h>
> +#warning "Please include asm/elf.h instead"
> +#endif	/* __KERNEL__ */
> +#endif

I think you forgot to remove this file when you removed MULTI_CPU.

	Arnd
