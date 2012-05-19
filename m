Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946428Ab2ESBIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:08:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55468 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764Ab2ESBIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:08:34 -0400
Message-ID: <4FB6F28F.3090404@tilera.com>
Date: Fri, 18 May 2012 21:08:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config
 file
References: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/2012 6:46 PM, Paul Gortmaker wrote:
> To fix this:
>
> ~/git/linux-head$ make defconfig
> *** Default configuration is based on 'tile_defconfig'
> ***
> *** Can't find default configuration "arch/tile/configs/tile_defconfig"!
> ***
> make[1]: *** [defconfig] Error 1
> make: *** [defconfig] Error 2
>
> There is no need to use $ARCH in the tile/Makefile, since if we are
> in there, we know ARCH must be tile.  Use the GX as the defconfig,
> as that is what is used in linux-next.

No, the odd thing about arch/tile is that you must build it either as
ARCH=tilepro or ARCH=tilegx.  There is no ARCH=tile.  So the $ARCH piece is
actually correct.

> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>
> diff --git a/arch/tile/Makefile b/arch/tile/Makefile
> index 5015144..89f2310 100644
> --- a/arch/tile/Makefile
> +++ b/arch/tile/Makefile
> @@ -34,7 +34,7 @@ LIBGCC_PATH     := \
>    $(shell $(CC) $(KBUILD_CFLAGS) $(KCFLAGS) -print-libgcc-file-name)
>  
>  # Provide the path to use for "make defconfig".
> -KBUILD_DEFCONFIG := $(ARCH)_defconfig
> +KBUILD_DEFCONFIG := tilegx_defconfig
>  
>  # Used as a file extension when useful, e.g. head_$(BITS).o
>  # Not needed for (e.g.) "$(CC) -m32" since the compiler automatically

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

