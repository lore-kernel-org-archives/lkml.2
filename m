Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1LAMMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:12:48 -0500
Received: from gw1-st.cellent-fs.de ([193.158.59.162]:5912 "EHLO
	mail.cellent-fs.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753346Ab1LAMMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:12:47 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 07:12:46 EST
X-AuditID: 0a01fe23-b7f4d6d000000d64-4a-4ed76bb6ef90
Subject: Re: [RFC][PATCH] ARM: kirkwood: Remove eSATA SheevaPlug board support
References: <1322737480.9622.5.camel@phoenix>
content-transfer-encoding: 8BIT
From: "Holland, John" <John.Holland@cellent-fs.de>
content-type: text/plain; charset="ISO-8859-1"
In-Reply-To: <1322737480.9622.5.camel@phoenix>
Message-ID: <73211F7E-A56E-4357-9C2A-E9E5E0EC522A@cellent-fs.de>
Date: Thu, 1 Dec 2011 12:57:35 +0100
thread-topic: [RFC][PATCH] ARM: kirkwood: Remove eSATA SheevaPlug board support
thread-index: AcywIG4UCuWZN+FBQPW9dlb+9/T6Iw==
To: "Axel Lin" <axel.lin@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "Nicolas Pitre" <nico@fluxnic.net>,
        "Lennert Buytenhek" <kernel@wantstofly.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
MIME-Version: 1.0 (1.0)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42LhYmTk0t2Wfd3PYMEkLosnKxazW/xaeprJ
	YtPja6wWl3fNYbO4fZnXYt6LF2wObB4tzT1sHs9OtLN57Jx1l91j85J6j8+b5DxW/WlhDWCL
	amC0SczLyy9JLElVSEktTrZV8klNT8xR8MxLyy/KTSzJzM9TcHYLVlLITLFVMlJSKMhJTE7N
	Tc0rsVVKLChIzUtRsuOyAQpm5imk5iXnp2TmpdsqeQb761pYmFrqGirZxRMCCT/ZMs4cuMxS
	8EuvYvrsySwNjHtVuxg5OSQETCS+rZrLBmGLSVy4tx7I5uIQEljHKDH11lJWCGcWo8SlXZvA
	qoQF/CRmzljO0sXIAZTQlTh2wxkkzCygLbFs4WtmEJtNwEiiYUEjWAmzgJ5E20ZGkDAnkPl8
	aRMrSJhXwEFi8uoUkDCLgIrEvyc7WEFsEQF/ieMHXzJD2HoSe169YIOwlSUOPFzPDrHpDKPE
	1TV2IDavgLhE99vDjBMYBWchOWIWwuJZSKoWMDKvYhTKTczM0UtOzckBhq9uWrFeSuomRnB0
	/1PewdjcoXeIUYCDUYmHNzL9up8Qa2JZcWXuIUYJDmYlEV6n99f8hHhTEiurUovy44tKc1KL
	DzH6AH0wkVlKNDkfmHjySuINjQ3MjI1NTC3MTExMcQgrifNq35jvJySQDkwS2ampBalFMOOY
	ODilGhir4xnmu3/QLVa7wLdXwE1UwFjK7erkXwL8Bk9f1T93s76nt0DJTfV1+cQDilVfcq9M
	ZO67Ylyy/8b3jUyu57RnKnycduj8M8/rDSs2tDrc5ra8zKBftLpqwry+/JV/L0eIxi4SOb/p
	yJqtJQ8/7N5Sx5XO/PU4y/v0SWZh5z/ZytY/XrNBe5u0EktxRqKhFnNRcSIAGqJLRxsDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2011, at 12:04, "Axel Lin" <axel.lin@gmail.com> wrote:

> commit bb9b25f923 "ARM: Update mach-types" removes sheeva_esata entry
> from mach-types, so current code in arch/arm/mach-kirkwood/sheevaplug-setup.c
> always compile fail.
> 
> This patch removes sheeva_esata related code.
> 
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: John Holland <john.holland@cellent-fs.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Not really sure if we should remove all sheeva_esata related code or
> just add it back to mach-types.
> If nobody cares, maybe it is ok to remove it.

I think removing the will also remove ESATA support for the device as a whole. I prefer reinstating the MACH_TYPE for the ESATA SheevaPlug.

> Note: 
> I got the build error on linux-next tree (20111201).
> So this patch is against linux-next tree.
> Axel
> 
> arch/arm/mach-kirkwood/Kconfig            |    6 ----
> arch/arm/mach-kirkwood/Makefile           |    1 -
> arch/arm/mach-kirkwood/sheevaplug-setup.c |   45 +---------------------------
> 3 files changed, 2 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
> index 7fc603b..f5ba3aa 100644
> --- a/arch/arm/mach-kirkwood/Kconfig
> +++ b/arch/arm/mach-kirkwood/Kconfig
> @@ -32,12 +32,6 @@ config MACH_SHEEVAPLUG
>      Say 'Y' here if you want your kernel to support the
>      Marvell SheevaPlug Reference Board.
> 
> -config MACH_ESATA_SHEEVAPLUG
> -    bool "Marvell eSATA SheevaPlug Reference Board"
> -    help
> -      Say 'Y' here if you want your kernel to support the
> -      Marvell eSATA SheevaPlug Reference Board.
> -
> config MACH_GURUPLUG
>    bool "Marvell GuruPlug Reference Board"
>    help
> diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
> index 5dcaa81..1cd300c 100644
> --- a/arch/arm/mach-kirkwood/Makefile
> +++ b/arch/arm/mach-kirkwood/Makefile
> @@ -5,7 +5,6 @@ obj-$(CONFIG_MACH_RD88F6192_NAS)    += rd88f6192-nas-setup.o
> obj-$(CONFIG_MACH_RD88F6281)        += rd88f6281-setup.o
> obj-$(CONFIG_MACH_MV88F6281GTW_GE)    += mv88f6281gtw_ge-setup.o
> obj-$(CONFIG_MACH_SHEEVAPLUG)        += sheevaplug-setup.o
> -obj-$(CONFIG_MACH_ESATA_SHEEVAPLUG)    += sheevaplug-setup.o
> obj-$(CONFIG_MACH_GURUPLUG)        += guruplug-setup.o
> obj-$(CONFIG_MACH_DOCKSTAR)        += dockstar-setup.o
> obj-$(CONFIG_MACH_TS219)        += ts219-setup.o tsx1x-common.o
> diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> index 85bff6b..346bb07 100644
> --- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
> +++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> @@ -11,7 +11,6 @@
> #include <linux/kernel.h>
> #include <linux/init.h>
> #include <linux/platform_device.h>
> -#include <linux/ata_platform.h>
> #include <linux/mtd/partitions.h>
> #include <linux/mv643xx_eth.h>
> #include <linux/gpio.h>
> @@ -43,19 +42,10 @@ static struct mv643xx_eth_platform_data sheevaplug_ge00_data = {
>    .phy_addr    = MV643XX_ETH_PHY_ADDR(0),
> };
> 
> -static struct mv_sata_platform_data sheeva_esata_sata_data = {
> -    .n_ports    = 2,
> -};
> -
> static struct mvsdio_platform_data sheevaplug_mvsdio_data = {
>    /* unfortunately the CD signal has not been connected */
> };
> 
> -static struct mvsdio_platform_data sheeva_esata_mvsdio_data = {
> -    .gpio_write_protect = 44, /* MPP44 used as SD write protect */
> -    .gpio_card_detect = 47,      /* MPP47 used as SD card detect */
> -};
> -
> static struct gpio_led sheevaplug_led_pins[] = {
>    {
>        .name            = "plug:red:misc",
> @@ -91,14 +81,6 @@ static unsigned int sheevaplug_mpp_config[] __initdata = {
>    0
> };
> 
> -static unsigned int sheeva_esata_mpp_config[] __initdata = {
> -    MPP29_GPIO,    /* USB Power Enable */
> -    MPP44_GPIO,    /* SD Write Protect */
> -    MPP47_GPIO,    /* SD Card Detect */
> -    MPP49_GPIO,    /* LED Green */
> -    0
> -};
> -
> static void __init sheevaplug_init(void)
> {
>    /*
> @@ -107,10 +89,7 @@ static void __init sheevaplug_init(void)
>    kirkwood_init();
> 
>    /* setup gpio pin select */
> -    if (machine_is_sheeva_esata())
> -        kirkwood_mpp_conf(sheeva_esata_mpp_config);
> -    else
> -        kirkwood_mpp_conf(sheevaplug_mpp_config);
> +    kirkwood_mpp_conf(sheevaplug_mpp_config);
> 
>    kirkwood_uart0_init();
>    kirkwood_nand_init(ARRAY_AND_SIZE(sheevaplug_nand_parts), 25);
> @@ -122,15 +101,7 @@ static void __init sheevaplug_init(void)
> 
>    kirkwood_ge00_init(&sheevaplug_ge00_data);
> 
> -    /* honor lower power consumption for plugs with out eSATA */
> -    if (machine_is_sheeva_esata())
> -        kirkwood_sata_init(&sheeva_esata_sata_data);
> -
> -    /* enable sd wp and sd cd on plugs with esata */
> -    if (machine_is_sheeva_esata())
> -        kirkwood_sdio_init(&sheeva_esata_mvsdio_data);
> -    else
> -        kirkwood_sdio_init(&sheevaplug_mvsdio_data);
> +    kirkwood_sdio_init(&sheevaplug_mvsdio_data);
> 
>    platform_device_register(&sheevaplug_leds);
> }
> @@ -147,15 +118,3 @@ MACHINE_START(SHEEVAPLUG, "Marvell SheevaPlug Reference Board")
>    .restart    = kirkwood_restart,
> MACHINE_END
> #endif
> -
> -#ifdef CONFIG_MACH_ESATA_SHEEVAPLUG
> -MACHINE_START(ESATA_SHEEVAPLUG, "Marvell eSATA SheevaPlug Reference Board")
> -    .atag_offset    = 0x100,
> -    .init_machine    = sheevaplug_init,
> -    .map_io        = kirkwood_map_io,
> -    .init_early    = kirkwood_init_early,
> -    .init_irq    = kirkwood_init_irq,
> -    .timer        = &kirkwood_timer,
> -    .restart    = kirkwood_restart,
> -MACHINE_END
> -#endif
> -- 
> 1.7.5.4
> 
> 
> 

___________________________________

Cellent Finance Solutions AG

Firmensitz: Calwer Straﬂe 33, 70173 Stuttgart
Registergericht: Amtsgericht Stuttgart, HRB 720743
Vorstand: Thomas Wild
Vorsitzender des Aufsichtsrats: Rudolf Zipf
