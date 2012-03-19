Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032702Ab2CSTrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:47:39 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:53263 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2CSTrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:47:37 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 15:47:36 EDT
Date: Mon, 19 Mar 2012 21:40:16 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Olof Johansson <olof@lixom.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] ARM: iop: add missing includes
Message-ID: <20120319194016.GA708@ultra.musicnaut.iki.fi>
References: <1329344682-29962-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329344682-29962-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 15, 2012 at 02:24:42PM -0800, Olof Johansson wrote:
> Resolves two build breaks. One is a boatload of "unknown type name 'u32'"
> in iop3xx.h due to missing include of <linux/types.h>.
> 
> The other is:
> arch/arm/plat-iop/restart.c: In function 'iop3xx_restart':
> arch/arm/plat-iop/restart.c:18:2: error: implicit declaration of function 'soft_restart' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Any chance to get this patch into 3.3.1 (stable), when and if such is made?

The v3.3 fails to build for IOP boards without this.

> ---
> 
>  arch/arm/include/asm/hardware/iop3xx.h |    2 ++
>  arch/arm/plat-iop/restart.c            |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/hardware/iop3xx.h b/arch/arm/include/asm/hardware/iop3xx.h
> index 077c323..ec0224d 100644
> --- a/arch/arm/include/asm/hardware/iop3xx.h
> +++ b/arch/arm/include/asm/hardware/iop3xx.h
> @@ -15,6 +15,8 @@
>  #ifndef __IOP3XX_H
>  #define __IOP3XX_H
>  
> +#include <linux/types.h>
> +
>  /*
>   * IOP3XX GPIO handling
>   */
> diff --git a/arch/arm/plat-iop/restart.c b/arch/arm/plat-iop/restart.c
> index 6a85a0c..a6ee3b6 100644
> --- a/arch/arm/plat-iop/restart.c
> +++ b/arch/arm/plat-iop/restart.c
> @@ -8,6 +8,7 @@
>   * published by the Free Software Foundation.
>   */
>  #include <asm/hardware/iop3xx.h>
> +#include <asm/system.h>
>  #include <mach/hardware.h>
>  
>  void iop3xx_restart(char mode, const char *cmd)
> -- 
> 1.7.9.209.gb6b3b

A.
