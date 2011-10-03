Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1JCOEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:04:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60695 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1JCOES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:04:18 -0400
Date: Mon, 3 Oct 2011 15:04:12 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/11] ARM: vfp: use -mfloat-abi=soft to build vfp
Message-ID: <20111003140411.GB2117@arm.com>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
 <1317496920-7764-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317496920-7764-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:21:54PM +0200, Arnd Bergmann wrote:
> Distros are starting to ship with toolchains defaulting to
> hardfloat. Using such a compiler to build the kernel fails
> in the VFP directory with
> 
> arch/arm/vfp/entry.S:1:0: sorry, unimplemented: -mfloat-abi=hard and VFP
> 
> Adding -mfloat-abi=soft to the gcc command line fixes this.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/vfp/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/vfp/Makefile b/arch/arm/vfp/Makefile
> index 6de73aa..a81404c 100644
> --- a/arch/arm/vfp/Makefile
> +++ b/arch/arm/vfp/Makefile
> @@ -7,7 +7,7 @@
>  # ccflags-y := -DDEBUG
>  # asflags-y := -DDEBUG
>  
> -KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa,-mfpu=softvfp+vfp)
> +KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa,-mfpu=softvfp+vfp -mfloat-abi=soft)

Although -mfpu=softvfp+vfp and -mfloat-abi=soft look mutually
contradictory, this seems to have the correct effect, i.e. the
assembler allows floating-point instructions but marks the resulting
object as using the soft-float calling conventions.

The binutils documentation also seems to confirm that that's what
should happen.

I don't see another combination of options for getting this effect.


So, if you like:

Reviewed-by: Dave Martin <dave.martin@linaro.org>

Cheers
---Dave
