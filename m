Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3ABKPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 05:15:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45896 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3ABKPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 05:15:43 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix
 build error
Thread-Topic: [PATCH] mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix
 build error
Thread-Index: AQHN1seiI6fLegAXTkGaMUde0EWBo5g18YqQ
Date: Wed, 2 Jan 2013 10:15:39 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EAD58CF@DBDE01.ent.ti.com>
References: <1355138096-7702-1-git-send-email-anilkumar@ti.com>
In-Reply-To: <1355138096-7702-1-git-send-email-anilkumar@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 16:44:56, AnilKumar, Chimata wrote:
> TPS65910 mfd driver uses functions that are only avaiable when
> REGMAP_IRQ is enabled. So "select REGMAP_IRQ" is added to mfd
> Kconfig to fix below build error:
> 
> drivers/built-in.o: In function `tps65910_irq_exit':
> /media/anil/kernel/drivers/mfd/tps65910.c:265: undefined reference to `regmap_del_irq_chip'
> drivers/built-in.o: In function `tps65910_irq_init':
> /media/anil/kernel/drivers/mfd/tps65910.c:254: undefined reference to `regmap_add_irq_chip'
> drivers/built-in.o: In function `tps65910_i2c_probe':
> /media/anil/kernel/drivers/mfd/tps65910.c:509: undefined reference to `regmap_irq_get_domain'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 1c0abd4..01413a2 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -237,6 +237,7 @@ config MFD_TPS65910
>  	depends on I2C=y && GPIOLIB
>  	select MFD_CORE
>  	select REGMAP_I2C
> +	select REGMAP_IRQ
>  	select IRQ_DOMAIN
>  	help
>  	  if you say yes here you get support for the TPS65910 series of

Hi Samuel,

Could you please pull this fix?

Thanks
AnilKumar
