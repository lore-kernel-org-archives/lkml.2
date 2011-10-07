Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab1JGISk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:18:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52383 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1JGISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-14-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-14-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 16:11:01 +0800
Message-ID: <CAMPhdO_CGvoc8GZQS3TWpv0gqOXhmHyEbamcQr28K5iLgOBnuw@mail.gmail.com>
Subject: Re: [PATCH 13/26] ARM: pxa: use correct __iomem annotations
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p978IlFf005906

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> This tries to clear up the confusion between integers and iomem pointers
> in the marvell pxa platform. MMIO addresses are supposed to be __iomem*
> values, in order to let the Linux type checking work correctly. This
> patch moves the cast to __iomem as far back as possible, to the place
> where the MMIO virtual address windows are defined.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/include/asm/hardware/it8152.h    |    2 +-
>  arch/arm/mach-mmp/clock.h                 |    8 ++++----
>  arch/arm/mach-mmp/common.c                |    4 ++--
>  arch/arm/mach-mmp/include/mach/addr-map.h |   10 ++++++++--
>  arch/arm/mach-mmp/mmp2.c                  |    3 ++-
>  arch/arm/mach-pxa/balloon3.c              |   10 +++++-----
>  arch/arm/mach-pxa/cm-x2xx-pci.c           |    2 +-
>  arch/arm/mach-pxa/cm-x2xx.c               |    4 ++--
>  arch/arm/mach-pxa/include/mach/addr-map.h |    8 ++++----
>  arch/arm/mach-pxa/include/mach/balloon3.h |    2 +-
>  arch/arm/mach-pxa/include/mach/hardware.h |    9 +++++----
>  arch/arm/mach-pxa/include/mach/lpd270.h   |    4 ++--
>  arch/arm/mach-pxa/include/mach/mtd-xip.h  |    1 -
>  arch/arm/mach-pxa/include/mach/palmtx.h   |    6 +++---
>  arch/arm/mach-pxa/include/mach/smemc.h    |    2 +-
>  arch/arm/mach-pxa/include/mach/zeus.h     |    4 ++--
>  arch/arm/mach-pxa/irq.c                   |    4 ++--
>  arch/arm/mach-pxa/lpd270.c                |    2 +-
>  arch/arm/mach-pxa/palmtx.c                |    8 ++++----
>  arch/arm/mach-pxa/pxa25x.c                |    2 +-
>  arch/arm/mach-pxa/pxa27x.c                |    2 +-
>  arch/arm/mach-pxa/pxa3xx.c                |    2 +-
>  arch/arm/mach-pxa/zeus.c                  |    8 ++++----
>  arch/arm/plat-pxa/gpio.c                  |    2 +-
>  arch/arm/plat-pxa/include/plat/mfp.h      |    2 +-
>  arch/arm/plat-pxa/mfp.c                   |    4 ++--
>  drivers/pcmcia/pxa2xx_balloon3.c          |    2 +-
>  drivers/video/mbx/mbxfb.c                 |    6 +++---
>  28 files changed, 65 insertions(+), 58 deletions(-)
>
> diff --git a/arch/arm/include/asm/hardware/it8152.h b/arch/arm/include/asm/hardware/it8152.h
> index b3fea38..43cab49 100644
> --- a/arch/arm/include/asm/hardware/it8152.h
> +++ b/arch/arm/include/asm/hardware/it8152.h
> @@ -9,7 +9,7 @@
>
>  #ifndef __ASM_HARDWARE_IT8152_H
>  #define __ASM_HARDWARE_IT8152_H
> -extern unsigned long it8152_base_address;
> +extern void __iomem *it8152_base_address;
>
>  #define IT8152_IO_BASE                 (it8152_base_address + 0x03e00000)
>  #define IT8152_CFGREG_BASE             (it8152_base_address + 0x03f00000)
> diff --git a/arch/arm/mach-mmp/clock.h b/arch/arm/mach-mmp/clock.h
> index 3143e99..149b30c 100644
> --- a/arch/arm/mach-mmp/clock.h
> +++ b/arch/arm/mach-mmp/clock.h
> @@ -30,7 +30,7 @@ extern struct clkops apmu_clk_ops;
>
>  #define APBC_CLK(_name, _reg, _fnclksel, _rate)                        \
>  struct clk clk_##_name = {                                     \
> -               .clk_rst        = (void __iomem *)APBC_##_reg,  \
> +               .clk_rst        = APBC_##_reg,                  \
>                .fnclksel       = _fnclksel,                    \
>                .rate           = _rate,                        \
>                .ops            = &apbc_clk_ops,                \
> @@ -38,7 +38,7 @@ struct clk clk_##_name = {                                    \
>
>  #define APBC_CLK_OPS(_name, _reg, _fnclksel, _rate, _ops)      \
>  struct clk clk_##_name = {                                     \
> -               .clk_rst        = (void __iomem *)APBC_##_reg,  \
> +               .clk_rst        = APBC_##_reg,                  \
>                .fnclksel       = _fnclksel,                    \
>                .rate           = _rate,                        \
>                .ops            = _ops,                         \
> @@ -46,7 +46,7 @@ struct clk clk_##_name = {                                    \
>
>  #define APMU_CLK(_name, _reg, _eval, _rate)                    \
>  struct clk clk_##_name = {                                     \
> -               .clk_rst        = (void __iomem *)APMU_##_reg,  \
> +               .clk_rst        = APMU_##_reg,                  \
>                .enable_val     = _eval,                        \
>                .rate           = _rate,                        \
>                .ops            = &apmu_clk_ops,                \
> @@ -54,7 +54,7 @@ struct clk clk_##_name = {                                    \
>
>  #define APMU_CLK_OPS(_name, _reg, _eval, _rate, _ops)          \
>  struct clk clk_##_name = {                                     \
> -               .clk_rst        = (void __iomem *)APMU_##_reg,  \
> +               .clk_rst        = APMU_##_reg,                  \
>                .enable_val     = _eval,                        \
>                .rate           = _rate,                        \
>                .ops            = _ops,                         \
> diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
> index 0ec0ca8..5720674 100644
> --- a/arch/arm/mach-mmp/common.c
> +++ b/arch/arm/mach-mmp/common.c
> @@ -27,12 +27,12 @@ EXPORT_SYMBOL(mmp_chip_id);
>  static struct map_desc standard_io_desc[] __initdata = {
>        {
>                .pfn            = __phys_to_pfn(APB_PHYS_BASE),
> -               .virtual        = APB_VIRT_BASE,
> +               .virtual        = (unsigned long)APB_VIRT_BASE,
>                .length         = APB_PHYS_SIZE,
>                .type           = MT_DEVICE,
>        }, {
>                .pfn            = __phys_to_pfn(AXI_PHYS_BASE),
> -               .virtual        = AXI_VIRT_BASE,
> +               .virtual        = (unsigned long)AXI_VIRT_BASE,
>                .length         = AXI_PHYS_SIZE,
>                .type           = MT_DEVICE,
>        },
> diff --git a/arch/arm/mach-mmp/include/mach/addr-map.h b/arch/arm/mach-mmp/include/mach/addr-map.h
> index 3254089..3e404ac 100644
> --- a/arch/arm/mach-mmp/include/mach/addr-map.h
> +++ b/arch/arm/mach-mmp/include/mach/addr-map.h
> @@ -11,6 +11,12 @@
>  #ifndef __ASM_MACH_ADDR_MAP_H
>  #define __ASM_MACH_ADDR_MAP_H
>
> +#ifndef __ASSEMBLER__
> +#define IOMEM(x)       ((void __iomem *)(x))
> +#else
> +#define IOMEM(x)       (x)
> +#endif
> +
>  /* APB - Application Subsystem Peripheral Bus
>  *
>  * NOTE: the DMA controller registers are actually on the AXI fabric #1
> @@ -18,11 +24,11 @@
>  * peripherals on APB, let's count it into the ABP mapping area.
>  */
>  #define APB_PHYS_BASE          0xd4000000
> -#define APB_VIRT_BASE          0xfe000000
> +#define APB_VIRT_BASE          IOMEM(0xfe000000)

To be honest, I'd really like to keep the *_VIRT_BASE definitions to be
type independent.

And have the actual register definitions to be casted to void __iomem *
when being defined, e.g.

#define APBC_REG(x)	IOMEM(APBC_VIRT_BASE + (x))

#define APBC_UART1	APBC_REG(0x000)

Arnd, do we have some standard guidelines on this for all SoCs
to follow? As I know, it's currently still being a mess.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
