Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab0FGX15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:27:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35736 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0FGX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:27:55 -0400
Date: Mon, 7 Jun 2010 19:27:51 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Mike Frysinger <vapier@gentoo.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs
 alignment
In-Reply-To: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.1.10.1006071920260.30720@dr-wily.mit.edu>
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Both patches look good.  Please consider them:

Acked-by: Tim Abbott <tabbott@ksplice.com>

	-Tim Abbott

On Sat, 5 Jun 2010, Mike Frysinger wrote:

> Add a new INIT_RAMFS() define to compliment the existing INIT_RAM_FS, but
> this one lets people control the alignment.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/asm-generic/vmlinux.lds.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
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
>  /*
>   * Default discarded sections.
> -- 
> 1.7.1
> 
> 
