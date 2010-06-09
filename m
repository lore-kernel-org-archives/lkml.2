Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0FIHUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:20:41 -0400
Received: from mail4.comsite.net ([205.238.176.238]:32697 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab0FIHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:20:40 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.20.111.250;
From: Milton Miller <miltonm@bga.com>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs
	alignment
In-Reply-To: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
Cc: <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@ksplice.com>,
       "H. Peter Anvin" <hpa@zytor.com>
X-To-Not-Matched: true
Date: Wed, 09 Jun 2010 02:20:30 -0500
X-Originating-IP: 71.20.111.250
Message-ID: <1276068030_13535@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat,  5 Jun 2010 at around 14:14:45 -0400, Mike Frysinger wrote:
> Add a new INIT_RAMFS() define to compliment the existing INIT_RAM_FS, but
> this one lets people control the alignment.
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 48c5299..9ca268f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -619,14 +619,15 @@ 
>  		VMLINUX_SYMBOL(__security_initcall_end) = .;
>  
>  #ifdef CONFIG_BLK_DEV_INITRD
> -#define INIT_RAM_FS							\
> -	. = ALIGN(PAGE_SIZE);						\
> +#define INIT_RAMFS(align)						\
> +	. = ALIGN(align);						\
>  	VMLINUX_SYMBOL(__initramfs_start) = .;				\
>  	*(.init.ramfs)							\
>  	VMLINUX_SYMBOL(__initramfs_end) = .;
>  #else
> -#define INIT_RAM_FS
> +#define INIT_RAMFS(align)
>  #endif
> +#define INIT_RAM_FS INIT_RAMFS(PAGE_SIZE)
>  

[ and patch 2/2 calls the new macro with align 4, for only blackfin ].

Mike,
As you identified, the alignment for the __initramfs is too large.

As can be seen by the grammer of the INIT_RAM_FS in [1], the section
itself always requires alignment of exactly 4 [2].

I realize it requires a bit more auditing and cordination, but we
should really just change the macro to align to 4.

[1] Documentation/early-userspace/buffer-format.txt,
[2] for the general case; as compressed fragments are aligin(1)

milton
