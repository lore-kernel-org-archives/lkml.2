Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0LWWNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:13:34 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:52998 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0LWWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:13:32 -0500
Date: Thu, 23 Dec 2010 15:13:29 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 3/4] of/powerpc: Use generic rule to build dtb's
Message-ID: <20101223221329.GJ20384@angua.secretlab.ca>
References: <1293047849-26078-1-git-send-email-dirk.brandewie@gmail.com>
 <1293047849-26078-4-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293047849-26078-4-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 11:57:28AM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Modify arch/powerpc/boot/Makefile to use dtc command in
> scripts/Makefile.lib
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

applied, thanks

g.

> ---
>  arch/powerpc/boot/Makefile |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
> index fae8192..96deec6 100644
> --- a/arch/powerpc/boot/Makefile
> +++ b/arch/powerpc/boot/Makefile
> @@ -35,7 +35,7 @@ endif
>  
>  BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
>  
> -DTS_FLAGS	?= -p 1024
> +DTC_FLAGS	?= -p 1024
>  
>  $(obj)/4xx.o: BOOTCFLAGS += -mcpu=405
>  $(obj)/ebony.o: BOOTCFLAGS += -mcpu=405
> @@ -332,10 +332,8 @@ $(obj)/treeImage.%: vmlinux $(obj)/%.dtb $(wrapperbits)
>  	$(call if_changed,wrap,treeboot-$*,,$(obj)/$*.dtb)
>  
>  # Rule to build device tree blobs
> -DTC = $(objtree)/scripts/dtc/dtc
> -
> -$(obj)/%.dtb: $(dtstree)/%.dts
> -	$(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(dtstree)/$*.dts
> +$(obj)/%.dtb: $(src)/dts/%.dts
> +	$(call cmd,dtc)
>  
>  # If there isn't a platform selected then just strip the vmlinux.
>  ifeq (,$(image-y))
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
