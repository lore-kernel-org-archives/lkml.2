Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1AFN4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:56:02 -0500
Received: from cantor.suse.de ([195.135.220.2]:42148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab1AFNz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:55:59 -0500
Date: Thu, 6 Jan 2011 14:55:58 +0100
From: Michal Marek <mmarek@suse.cz>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel build ignores missing mkimage on building uImage
Message-ID: <20110106135558.GC1841@sepie.suse.cz>
References: <4D0B8D85.5090605@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0B8D85.5090605@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 05:19:17PM +0100, Roland Stigge wrote:
> Hi,
> 
> on building an uImage, I get:
> 
> $ make uImage
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   Kernel: arch/arm/boot/Image is ready
>   SHIPPED arch/arm/boot/compressed/lib1funcs.S
>   AS      arch/arm/boot/compressed/lib1funcs.o
>   LD      arch/arm/boot/compressed/vmlinux
>   OBJCOPY arch/arm/boot/zImage
>   Kernel: arch/arm/boot/zImage is ready
>   UIMAGE  arch/arm/boot/uImage
> "mkimage" command not found - U-Boot images will not be built
>   Image arch/arm/boot/uImage is ready
> $
> 
> I.e. it says: "uImage is ready" even though the uImage file doesn't
> exist because mkimage is missing.
> 
> (I'm working with Linux' current mainline GIT and also see that the
> problem is also present in the mmarek repo on git.kernel.org.)
> 
> I propose the attached patch.
> 
> Thanks for considering.

The patch makes sense and afaics none of the architectures relies on
this behaviour (either they can't work without mkimage, or a
uimage-style target has to be requested by the user). Can I assume
"Signed-off-by: Roland Stigge <stigge@antcom.de>" on this patch.

Thanks,
Michal
> 
> bye,
>   Roland

> diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
> index 2e3d3cd..446739c 100755
> --- a/scripts/mkuboot.sh
> +++ b/scripts/mkuboot.sh
> @@ -11,7 +11,7 @@ if [ -z "${MKIMAGE}" ]; then
>  	if [ -z "${MKIMAGE}" ]; then
>  		# Doesn't exist
>  		echo '"mkimage" command not found - U-Boot images will not be built' >&2
> -		exit 0;
> +		exit 1;
>  	fi
>  fi
>  

