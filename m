Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2HIVND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:13:03 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35441 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2HIVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:13:00 -0400
Date: Thu, 9 Aug 2012 17:12:58 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH 04/10] ARM: pass -marm to gcc by default
In-Reply-To: <1344461278-28245-5-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1208091709010.5231@xanadu.home>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-5-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Arnd Bergmann wrote:

> The Linaro cross toolchain and probably others nowadays default to
> building in THUMB2 mode. When building a kernel for a CPU that does
> not support THUMB2, the compiler complains about incorrect flags.
> We can work around this by setting -marm for all non-T2 builds.
> 
> Without this patch, building assabet_defconfig results in:
> 
> usr/initramfs_data.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
> arch/arm/nwfpe/entry.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
> firmware/cis/PCMLM28.cis.gen.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
> (and many more)
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Dave Martin <dave.martin@linaro.org>
> ---
>  arch/arm/Makefile |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 30eae87..b4c2296 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -111,6 +111,9 @@ AFLAGS_THUMB2	:=$(CFLAGS_THUMB2) -Wa$(comma)-mthumb
>  ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JUMP11),y)
>  CFLAGS_MODULE	+=-fno-optimize-sibling-calls
>  endif
> +else
> +CFLAGS_THUMB2  :=-marm
> +AFLAGS_THUMB2	:=-marm

CFLAGS_THUMB2 should probably be renamed to something more appropriate 
in this case, e.g. CFLAGS_MODE.


Nicolas
