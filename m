Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1AERAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:00:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26311 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1AERAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:00:05 -0500
Date: Wed, 5 Jan 2011 08:59:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Angelo Dureghello <angelo70@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] m68knommu: added dm9000 support
Message-Id: <20110105085930.676fa5ce.randy.dunlap@oracle.com>
In-Reply-To: <4D24A0E4.1070805@gmail.com>
References: <4D24A0E4.1070805@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jan 2011 17:48:36 +0100 Angelo Dureghello wrote:

> This patch allows to use the dm9000 network chip with a m68knommu 
> big-endian cpu. From the HW point of view, the cpu data bus connected to 
> the dm9000 chip should be hardware-byte-swapped, crossing the bytes 
> wires (D0:7 to D24:31, etc.). In anyway, has been also added an option 
> to swap the bytes in the driver, if some cpu has been wired straight 
> D0:D31 to dm9000.
> 
> Signed-off-by: Angelo Dureghello <angelo70@gmail.com>
> ---
> 
> --- drivers/net/Kconfig.orig  2011-01-05 17:11:37.992376124 +0100
> +++ drivers/net/Kconfig 2011-01-04 22:33:14.132301872 +0100

File names should begin at top level of linux kernel source tree, like this e.g.:

> --- linux/drivers/net/Kconfig.orig  2011-01-05 17:11:37.992376124 +0100
> +++ linux/drivers/net/Kconfig 2011-01-04 22:33:14.132301872 +0100


> @@ -960,7 +960,7 @@ config TI_DAVINCI_EMAC
> 
>   config DM9000
>     tristate "DM9000 support"
> -  depends on ARM || BLACKFIN || MIPS
> +  depends on COLDFIRE || ARM || BLACKFIN || MIPS
>     select CRC32
>     select MII
>     ---help---

Something has modified tab(s) to spaces in this patch, so the patch won't
apply cleanly.  See if Documentation/email-clients.txt can help you.

Oh, are you using the gmail web-based email client?  That won't work
for kernel patches.  You could use gmail via SMTP.


> @@ -986,6 +986,14 @@ config DM9000_FORCE_SIMPLE_PHY_POLL
>       costly MII PHY reads. Note, this will not work if the chip is
>       operating with an external PHY.
> 
> +config DM9000_32BIT_SW_SWAP
> +  bool "Software byte swap for 32 bit data bus"
> +  depends on DM9000 && COLDFIRE
> +  ---help---
> +    This configuration allows to swap data bytes from the dm9000
> +    driver itself, when the big endian cpu is wired straight to
> +    the dm9000 32 bit data bus.
> +
>   config ENC28J60
>     tristate "ENC28J60 support"
>     depends on EXPERIMENTAL && SPI && NET_ETHERNET


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
