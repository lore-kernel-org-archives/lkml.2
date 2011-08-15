Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1HOTXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:23:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:55394 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HOTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:23:03 -0400
Message-ID: <4E4971FC.3080601@windriver.com>
Date: Mon, 15 Aug 2011 15:22:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] avr32/clock.c: Move '#include linux/export.h' to fix
 build failure
References: <1313431320-17080-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1313431320-17080-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-15 02:02 PM, Peter Huewe wrote:
> This patch fixes a build failure for the avr32 defconfig by moving the include
> of linux/export.h to the top of the file where it is needed.
> 
> Without the patch the build first warns about:
> arch/avr32/mach-at32ap/clock.c:62: warning: data definition has no type
> or storage class
> arch/avr32/mach-at32ap/clock.c:62: warning: type defaults to 'int' in
> declaration of 'EXPORT_SYMBOL'
> arch/avr32/mach-at32ap/clock.c:62: warning: parameter names (without
> types) in function declaration
> (...)
> 
> And then fails with
> ERROR: "clk_enable" [sound/spi/snd-at73c213.ko] undefined!
> ERROR: "clk_disable" [sound/spi/snd-at73c213.ko] undefined!
> (...)
> 
> This is because the definition of EXPORT_SYMBOL is needed before the
> first usage, and thus the include has to be on the top of the file.

Thanks Peter,  I'll squish this fix into the commit that introduces
the misplacement.  It was searching out the last "#include <linux/xyz.h>
and appending after that.  Occasionally where someone has a large
block of them in an #ifdef CONFIG_BLAH did it get misplaced.  And then
it was only visible if the arch didn't set CONFIG_BLAH, as what has
happened here on avr32 it seems.

Paul.

> 
> While at it, I sorted the include list alphabetically.
> 
> KernelVersion: Linux-next 20110812
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  arch/avr32/mach-at32ap/clock.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
> index 579d619..78c873a 100644
> --- a/arch/avr32/mach-at32ap/clock.c
> +++ b/arch/avr32/mach-at32ap/clock.c
> @@ -12,10 +12,11 @@
>   * published by the Free Software Foundation.
>   */
>  #include <linux/clk.h>
> -#include <linux/err.h>
>  #include <linux/device.h>
> -#include <linux/string.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
>  #include <linux/list.h>
> +#include <linux/string.h>
>  
>  #include <mach/chip.h>
>  
> @@ -186,7 +187,6 @@ EXPORT_SYMBOL(clk_get_parent);
>  #include <linux/io.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> -#include <linux/export.h>
>  #include "pm.h"
>  
>  
