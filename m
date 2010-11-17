Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab0KQGHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:07:00 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33690 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab0KQGG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:06:59 -0500
Date: Tue, 16 Nov 2010 23:06:53 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        microblaze-uclinux@itee.uq.edu.au, arjan@linux.intel.com
Subject: Re: [PATCH 4/5] of/powerpc: Move build to use generic dts->dtb rule
Message-ID: <20101117060653.GI12813@angua.secretlab.ca>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
 <dae91d8292876db96f96896b79076c32cd2bf467.1289943240.git.dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dae91d8292876db96f96896b79076c32cd2bf467.1289943240.git.dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:41:39PM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch changes arch/powerpc/boot/Makefile to use the generic
> rule build the device tree blobs in scripts/Makefile.lib
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  arch/powerpc/boot/Makefile |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
> index fae8192..d90c674 100644
> --- a/arch/powerpc/boot/Makefile
> +++ b/arch/powerpc/boot/Makefile
> @@ -147,8 +147,6 @@ targets		+= $(patsubst $(obj)/%,%,$(obj-boot) wrapper.a)
>  extra-y		:= $(obj)/wrapper.a $(obj-plat) $(obj)/empty.o \
>  		   $(obj)/zImage.lds $(obj)/zImage.coff.lds $(obj)/zImage.ps3.lds
>  
> -dtstree		:= $(srctree)/$(src)/dts
> -
>  wrapper		:=$(srctree)/$(src)/wrapper
>  wrapperbits	:= $(extra-y) $(addprefix $(obj)/,addnote hack-coff mktree) \
>  			$(wrapper) FORCE
> @@ -331,11 +329,6 @@ $(obj)/treeImage.initrd.%: vmlinux $(obj)/%.dtb $(wrapperbits)
>  $(obj)/treeImage.%: vmlinux $(obj)/%.dtb $(wrapperbits)
>  	$(call if_changed,wrap,treeboot-$*,,$(obj)/$*.dtb)
>  
> -# Rule to build device tree blobs
> -DTC = $(objtree)/scripts/dtc/dtc
> -
> -$(obj)/%.dtb: $(dtstree)/%.dts
> -	$(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(dtstree)/$*.dts

This patch needs to modify the rules that have %.dtb dependencies to
go looking in arch/powerpc/boot/dts instead of arch/powerpc/boot
because the rule change will change where .dtb files get generated.

Also, this patch and patch 5 need to be merged with patch 1 so that
the series remains bisectable.

g.

>  
>  # If there isn't a platform selected then just strip the vmlinux.
>  ifeq (,$(image-y))
> -- 
> 1.7.2.3
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
