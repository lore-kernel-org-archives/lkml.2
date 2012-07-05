Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2GEX6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:58:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55100 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2GEX6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <e40881dd-ba8c-468b-bb27-220339fc4a5c@AM1EHSMHS001.ehs.local>
References: <e40881dd-ba8c-468b-bb27-220339fc4a5c@AM1EHSMHS001.ehs.local>
Date: Thu, 5 Jul 2012 16:58:02 -0700
Message-ID: <CAB9O=COFN3HFy5h1Eka=29y7byoow4YVv55ciuOUorZuK40x0g@mail.gmail.com>
Subject: Re: FW: [PATCH 1/3] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
From: John Linn <johnhlinn@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nbowler@elliptictech.com
Cc: linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:32 PM, John Linn <John.Linn@xilinx.com> wrote:
>
>
> -----Original Message-----
> From: Nick Bowler [mailto:nbowler@elliptictech.com]
> Sent: Wednesday, July 04, 2012 7:14 AM
> To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Cc: Russell King; John Linn
> Subject: [PATCH 1/3] ARM: zynq: Allow UART1 to be used as DEBUG_LL
> console.
>
> The main UART on the Xilinx ZC702 board is UART1, located at address
> e0001000.  Add a Kconfig option to select this device as the low-level
> debugging port.  This allows the really early boot printouts to reach
> the USB serial adaptor on this board.
>
> The board does not boot yet, but now it's actually possible to see error
> messages.
>
> For consistency's sake, add a choice entry for UART0 even though it is
> the the default if UART1 is not selected.
>
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> Cc: John Linn <john.linn@xilinx.com>

Signed-off-by: John Linn <johnhlinn@gmail.com>

I tested it with the other patches and another small change on the 702 board.
Using my gmail account as I'm still fighting to get legal footers
turned off in Xilinx mail.

Thanks
John

>
> ---
>  arch/arm/Kconfig.debug                     |   17 +++++++++++++++++
>  arch/arm/mach-zynq/common.c                |    4 ++--
>  arch/arm/mach-zynq/include/mach/zynq_soc.h |   12 ++++++++++--
>  3 files changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 01a1341..9abe3ad 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -132,6 +132,23 @@ choice
>                   their output to UART1 serial port on DaVinci TNETV107X
>                   devices.
>
> +       config DEBUG_ZYNQ_UART0
> +               bool "Kernel low-level debugging on Xilinx Zynq using
> UART0"
> +               depends on ARCH_ZYNQ
> +               help
> +                 Say Y here if you want the debug print routines to
> direct
> +                 their output to UART0 on the Zynq platform.
> +
> +       config DEBUG_ZYNQ_UART1
> +               bool "Kernel low-level debugging on Xilinx Zynq using
> UART1"
> +               depends on ARCH_ZYNQ
> +               help
> +                 Say Y here if you want the debug print routines to
> direct
> +                 their output to UART1 on the Zynq platform.
> +
> +                 If you have a ZC702 board and want early boot messages
> to
> +                 appear on the USB serial adaptor, select this option.
> +
>         config DEBUG_DC21285_PORT
>                 bool "Kernel low-level debugging messages via footbridge
> serial port"
>                 depends on FOOTBRIDGE
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index ab5cfdd..12a2984 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -87,8 +87,8 @@ static struct map_desc io_desc[] __initdata = {
>
>  #ifdef CONFIG_DEBUG_LL
>         {
> -               .virtual        = UART0_VIRT,
> -               .pfn            = __phys_to_pfn(UART0_PHYS),
> +               .virtual        = LL_UART_VADDR,
> +               .pfn            = __phys_to_pfn(LL_UART_PADDR),
>                 .length         = SZ_4K,
>                 .type           = MT_DEVICE,
>         },
> diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> index d0d3f8f..6f83f1c 100644
> --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> @@ -22,6 +22,9 @@
>  #define UART0_PHYS                     0xE0000000
>  #define UART0_VIRT                     UART0_PHYS
>
> +#define UART1_PHYS                     0xE0001000
> +#define UART1_VIRT                     UART1_PHYS
> +
>  #define TTC0_PHYS                      0xF8001000
>  #define TTC0_VIRT                      TTC0_PHYS
>
> @@ -42,7 +45,12 @@
>  /*
>   * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
>   */
> -#define LL_UART_PADDR  UART0_PHYS
> -#define LL_UART_VADDR  UART0_VIRT
> +#ifdef CONFIG_DEBUG_ZYNQ_UART1
> +#  define LL_UART_PADDR UART1_PHYS
> +#  define LL_UART_VADDR UART1_VIRT
> +#else
> +#  define LL_UART_PADDR UART0_PHYS
> +#  define LL_UART_VADDR UART0_VIRT
> +#endif
>
>  #endif
> --
> 1.7.8.6
>
>
