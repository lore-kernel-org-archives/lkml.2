Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab1LIKTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:19:44 -0500
Received: from smtp-out-081.synserver.de ([212.40.185.81]:1064 "EHLO
	smtp-out-081.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1LIKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:19:43 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6325
Message-ID: <4EE1E0D5.7080006@metafoo.de>
Date: Fri, 09 Dec 2011 11:20:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: jz4740-adc: Include linux/io.h
References: <1323401275.25140.0.camel@phoenix>
In-Reply-To: <1323401275.25140.0.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 04:27 AM, Axel Lin wrote:
> Include linux/io.h to fix below build error:
> 
>   CC      drivers/mfd/jz4740-adc.o
> drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_irq_demux':
> drivers/mfd/jz4740-adc.c:73: error: implicit declaration of function 'readb'
> drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_set_enabled':
> drivers/mfd/jz4740-adc.c:110: error: implicit declaration of function 'writeb'
> drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_set_config':
> drivers/mfd/jz4740-adc.c:146: error: implicit declaration of function 'readl'
> drivers/mfd/jz4740-adc.c:151: error: implicit declaration of function 'writel'
> drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_probe':
> drivers/mfd/jz4740-adc.c:249: error: implicit declaration of function 'ioremap_nocache'
> drivers/mfd/jz4740-adc.c:249: warning: assignment makes pointer from integer without a cast
> drivers/mfd/jz4740-adc.c:289: warning: passing argument 3 of 'mfd_add_devices' discards qualifiers from pointer target type
> include/linux/mfd/core.h:93: note: expected 'struct mfd_cell *' but argument is of type 'const struct mfd_cell *'
> drivers/mfd/jz4740-adc.c:299: error: implicit declaration of function 'iounmap'
> make[2]: *** [drivers/mfd/jz4740-adc.o] Error 1
> make[1]: *** [drivers/mfd] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/mfd/jz4740-adc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 1e9ee53..ef39528 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -16,6 +16,7 @@
>   */
>  
>  #include <linux/err.h>
> +#include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>

