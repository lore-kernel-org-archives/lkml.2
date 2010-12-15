Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0LOJPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:15:51 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7166 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0LOJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:15:49 -0500
Date: Wed, 15 Dec 2010 10:15:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] GPIO_SCH and I2C_SCH: select MFD_SUPPORT to eliminate 
 kconfig warnings
Message-ID: <20101215101541.5952780f@endymion.delvare>
In-Reply-To: <20101214162656.b8550c70.randy.dunlap@oracle.com>
References: <20101214162656.b8550c70.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Tue, 14 Dec 2010 16:26:56 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> I2C_ISCH and GPIO_SCH need to select MFD_SUPPORT so that the
> dependency tree hierarchy is satisfied.  This eliminates the
> kconfig warning:
> 
> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI) selects LPC_SCH which has unmet direct dependencies (MFD_SUPPORT && PCI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: linux-i2c@vger.kernel.org
> ---
>  drivers/gpio/Kconfig       |    1 +
>  drivers/i2c/busses/Kconfig |    1 +
>  2 files changed, 2 insertions(+)
> 
> --- lnx-2637-rc4.orig/drivers/gpio/Kconfig
> +++ lnx-2637-rc4/drivers/gpio/Kconfig
> @@ -102,6 +102,7 @@ config GPIO_VR41XX
>  config GPIO_SCH
>  	tristate "Intel SCH GPIO"
>  	depends on GPIOLIB && PCI
> +	select MFD_SUPPORT
>  	select MFD_CORE
>  	select LPC_SCH
>  	help
> --- lnx-2637-rc4.orig/drivers/i2c/busses/Kconfig
> +++ lnx-2637-rc4/drivers/i2c/busses/Kconfig
> @@ -107,6 +107,7 @@ config I2C_I801
>  config I2C_ISCH
>  	tristate "Intel SCH SMBus 1.0"
>  	depends on PCI
> +	select MFD_SUPPORT
>  	select MFD_CORE
>  	select LPC_SCH
>  	help

It seems wrong to have to select both MFD_SUPPORT and MFD_CORE. Can't
the MFD subsystem be cleaned up so that subdrivers have a single symbol
to select beyond their own?

I don't quite get the point of MFD_CORE. MFD_SUPPORT could be made
tristate, and MFD_CORE dropped (and then MFD_SUPPORT renamed to
MFD_CORE to minimize the changes.) This is exactly how I2C support is
implemented, for example.

-- 
Jean Delvare
