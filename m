Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1JNNd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:33:58 -0400
Received: from ra.se.axis.com ([195.60.68.13]:47985 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab1JNNd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:33:57 -0400
Date: Fri, 14 Oct 2011 15:33:54 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] cris: drop unused Kconfig symbols
Message-ID: <20111014133354.GE9412@axis.com>
References: <1318595467.6132.80.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318595467.6132.80.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... NAK on that. Lots of these configs are actually used, but in drivers
not upstream yet (serial port, ethernet and usb drivers for ARTPEC-3).

However, the following seem to truly be unused:

ETRAX_NANDFLASH_BUSWIDTH
ETRAX_PA_BUTTON_BITMASK
ETRAX_DDR

If you send a modified patch with just those configs I will be happy. :-)

Thanks,

/Jesper

On Fri, Oct 14, 2011 at 02:31:07PM +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/cris/Kconfig                  |   49 -----
>  arch/cris/arch-v10/drivers/Kconfig |   23 ---
>  arch/cris/arch-v32/drivers/Kconfig |  380 ------------------------------------
>  arch/cris/arch-v32/mach-a3/Kconfig |    4 -
>  4 files changed, 0 insertions(+), 456 deletions(-)
> 
> diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
> index 17addac..6a0dc11 100644
> --- a/arch/cris/Kconfig
> +++ b/arch/cris/Kconfig
> @@ -98,9 +98,6 @@ config ETRAX_KMALLOCED_MODULES
>         help
>           Enable module allocation with kmalloc instead of vmalloc.
> 
> -config OOM_REBOOT
> -       bool "Enable reboot at out of memory"
> -
>  source "kernel/Kconfig.preempt"
> 
>  source mm/Kconfig
> @@ -177,12 +174,6 @@ config ETRAX_FLASH_BUSWIDTH
>         help
>           Width in bytes of the NOR Flash bus (1, 2 or 4). Is usually 2.
> 
> -config ETRAX_NANDFLASH_BUSWIDTH
> -       int "Buswidth of NAND flash in bytes"
> -       default "1"
> -       help
> -         Width in bytes of the NAND flash (1 or 2).
> -
>  config ETRAX_FLASH1_SIZE
>         int "FLASH1 size (dec, in MB. 0 = Unknown)"
>         default "0"
> @@ -581,26 +572,6 @@ config ETRAX_SERIAL_PORT3_DMA5_IN
>         depends on ETRAX_ARCH_V10
>         bool "DMA 5"
> 
> -config ETRAX_SERIAL_PORT3_DMA9_IN
> -       bool "Ser3 uses DMA9 for input"
> -       depends on ETRAXFS
> -       help
> -         Enables the DMA9 input channel for ser3 (ttyS3).
> -         If you do not enable DMA, an interrupt for each character will be
> -         used when receiving data.
> -         Normally you want to use DMA, unless you use the DMA channel for
> -         something else.
> -
> -config ETRAX_SERIAL_PORT3_DMA3_IN
> -       bool "Ser3 uses DMA3 for input"
> -       depends on CRIS_MACH_ARTPEC3
> -       help
> -         Enables the DMA3 input channel for ser3 (ttyS3).
> -         If you do not enable DMA, an interrupt for each character will be
> -         used when receiving data.
> -         Normally you want to use DMA, unless you use the DMA channel for
> -         something else.
> -
>  endchoice
> 
>  choice
> @@ -618,26 +589,6 @@ config ETRAX_SERIAL_PORT3_DMA4_OUT
>         depends on ETRAX_ARCH_V10
>         bool "DMA 4"
> 
> -config ETRAX_SERIAL_PORT3_DMA8_OUT
> -       bool "Ser3 uses DMA8 for output"
> -       depends on ETRAXFS
> -       help
> -         Enables the DMA8 output channel for ser3 (ttyS3).
> -         If you do not enable DMA, an interrupt for each character will be
> -         used when transmitting data.
> -         Normally you want to use DMA, unless you use the DMA channel for
> -         something else.
> -
> -config ETRAX_SERIAL_PORT3_DMA2_OUT
> -       bool "Ser3 uses DMA2 for output"
> -       depends on CRIS_MACH_ARTPEC3
> -       help
> -         Enables the DMA2 output channel for ser3 (ttyS3).
> -         If you do not enable DMA, an interrupt for each character will be
> -         used when transmitting data.
> -         Normally you want to use DMA, unless you use the DMA channel for
> -         something else.
> -
>  endchoice
> 
>  endmenu
> diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
> index 0d72217..12f2f04 100644
> --- a/arch/cris/arch-v10/drivers/Kconfig
> +++ b/arch/cris/arch-v10/drivers/Kconfig
> @@ -418,16 +418,6 @@ config ETRAX_USB_HOST
>            for CTRL and BULK traffic only, INTR traffic may work as well
>            however (depending on the requirements of timeliness).
> 
> -config ETRAX_USB_HOST_PORT1
> -       bool "USB port 1 enabled"
> -       depends on ETRAX_USB_HOST
> -       default n
> -
> -config ETRAX_USB_HOST_PORT2
> -       bool "USB port 2 enabled"
> -       depends on ETRAX_USB_HOST
> -       default n
> -
>  config ETRAX_PTABLE_SECTOR
>         int "Byte-offset of partition table sector"
>         depends on ETRAX_AXISFLASHMAP
> @@ -528,19 +518,6 @@ config ETRAX_GPIO
>           Remember that you need to setup the port directions appropriately in
>           the General configuration.
> 
> -config ETRAX_PA_BUTTON_BITMASK
> -       hex "PA-buttons bitmask"
> -       depends on ETRAX_GPIO
> -       default "02"
> -       help
> -         This is a bitmask with information about what bits on PA that
> -         are used for buttons.
> -         Most products has a so called TEST button on PA1, if that's true
> -         use 02 here.
> -         Use 00 if there are no buttons on PA.
> -         If the bitmask is <> 00 a button driver will be included in the gpio
> -         driver. ETRAX general I/O support must be enabled.
> -
>  config ETRAX_PA_CHANGEABLE_DIR
>         hex "PA user changeable dir mask"
>         depends on ETRAX_GPIO
> diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
> index 41a2732..3488a79 100644
> --- a/arch/cris/arch-v32/drivers/Kconfig
> +++ b/arch/cris/arch-v32/drivers/Kconfig
> @@ -28,56 +28,6 @@ config ETRAX_ETHERNET_IFACE1
>         depends on (ETRAX_ETHERNET && ETRAXFS)
>         bool "Enable network interface 1 (uses DMA6 and DMA7)"
> 
> -config ETRAX_ETHERNET_GBIT
> -       depends on (ETRAX_ETHERNET && CRIS_MACH_ARTPEC3)
> -       bool "Enable gigabit Ethernet support"
> -
> -choice
> -       prompt "Eth0 led group"
> -       depends on ETRAX_ETHERNET_IFACE0
> -       default ETRAX_ETH0_USE_LEDGRP0
> -
> -config ETRAX_ETH0_USE_LEDGRP0
> -       bool "Use LED grp 0"
> -       depends on ETRAX_NBR_LED_GRP_ONE || ETRAX_NBR_LED_GRP_TWO
> -       help
> -         Use LED grp 0 for eth0
> -
> -config ETRAX_ETH0_USE_LEDGRP1
> -       bool "Use LED grp 1"
> -       depends on ETRAX_NBR_LED_GRP_TWO
> -       help
> -         Use LED grp 1 for eth0
> -
> -config ETRAX_ETH0_USE_LEDGRPNULL
> -       bool "Use no LEDs for eth0"
> -       help
> -         Use no LEDs for eth0
> -endchoice
> -
> -choice
> -       prompt "Eth1 led group"
> -       depends on ETRAX_ETHERNET_IFACE1
> -       default ETRAX_ETH1_USE_LEDGRP1
> -
> -config ETRAX_ETH1_USE_LEDGRP0
> -       bool "Use LED grp 0"
> -       depends on ETRAX_NBR_LED_GRP_ONE || ETRAX_NBR_LED_GRP_TWO
> -       help
> -         Use LED grp 0 for eth1
> -
> -config ETRAX_ETH1_USE_LEDGRP1
> -       bool "Use LED grp 1"
> -       depends on ETRAX_NBR_LED_GRP_TWO
> -       help
> -         Use LED grp 1 for eth1
> -
> -config ETRAX_ETH1_USE_LEDGRPNULL
> -       bool "Use no LEDs for eth1"
> -       help
> -         Use no LEDs for eth1
> -endchoice
> -
>  config ETRAXFS_SERIAL
>         bool "Serial-port support"
>         depends on ETRAX_ARCH_V32
> @@ -109,261 +59,30 @@ config ETRAX_SERIAL_PORT0
>           if you do not need DMA to something else.
>           ser0 can use dma4 or dma6 for output and dma5 or dma7 for input.
> 
> -choice
> -       prompt "Ser0 default port type "
> -       depends on ETRAX_SERIAL_PORT0
> -       default ETRAX_SERIAL_PORT0_TYPE_232
> -       help
> -         Type of serial port.
> -
> -config ETRAX_SERIAL_PORT0_TYPE_232
> -       bool "Ser0 is a RS-232 port"
> -       help
> -         Configure serial port 0 to be a RS-232 port.
> -
> -config ETRAX_SERIAL_PORT0_TYPE_485HD
> -       bool "Ser0 is a half duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 0 to be a half duplex (two wires) RS-485 port.
> -
> -config ETRAX_SERIAL_PORT0_TYPE_485FD
> -       bool "Ser0 is a full duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 0 to be a full duplex (four wires) RS-485 port.
> -endchoice
> -
> -config ETRAX_SER0_DTR_BIT
> -       string "Ser 0 DTR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT0
> -
> -config ETRAX_SER0_RI_BIT
> -       string "Ser 0 RI bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT0
> -
> -config ETRAX_SER0_DSR_BIT
> -       string "Ser 0 DSR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT0
> -
> -config ETRAX_SER0_CD_BIT
> -       string "Ser 0 CD bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT0
> -
>  config ETRAX_SERIAL_PORT1
>         bool "Serial port 1 enabled"
>         depends on ETRAXFS_SERIAL
>         help
>           Enables the ETRAX FS serial driver for ser1 (ttyS1).
> 
> -choice
> -       prompt "Ser1 default port type"
> -       depends on ETRAX_SERIAL_PORT1
> -       default ETRAX_SERIAL_PORT1_TYPE_232
> -       help
> -         Type of serial port.
> -
> -config ETRAX_SERIAL_PORT1_TYPE_232
> -       bool "Ser1 is a RS-232 port"
> -       help
> -         Configure serial port 1 to be a RS-232 port.
> -
> -config ETRAX_SERIAL_PORT1_TYPE_485HD
> -       bool "Ser1 is a half duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 1 to be a half duplex (two wires) RS-485 port.
> -
> -config ETRAX_SERIAL_PORT1_TYPE_485FD
> -       bool "Ser1 is a full duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 1 to be a full duplex (four wires) RS-485 port.
> -endchoice
> -
> -config ETRAX_SER1_DTR_BIT
> -       string "Ser 1 DTR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT1
> -
> -config ETRAX_SER1_RI_BIT
> -       string "Ser 1 RI bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT1
> -
> -config ETRAX_SER1_DSR_BIT
> -       string "Ser 1 DSR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT1
> -
> -config ETRAX_SER1_CD_BIT
> -       string "Ser 1 CD bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT1
> -
>  config ETRAX_SERIAL_PORT2
>         bool "Serial port 2 enabled"
>         depends on ETRAXFS_SERIAL
>         help
>           Enables the ETRAX FS serial driver for ser2 (ttyS2).
> 
> -choice
> -       prompt "Ser2 default port type"
> -       depends on ETRAX_SERIAL_PORT2
> -       default ETRAX_SERIAL_PORT2_TYPE_232
> -       help
> -         What DMA channel to use for ser2
> -
> -config ETRAX_SERIAL_PORT2_TYPE_232
> -       bool "Ser2 is a RS-232 port"
> -       help
> -         Configure serial port 2 to be a RS-232 port.
> -
> -config ETRAX_SERIAL_PORT2_TYPE_485HD
> -       bool "Ser2 is a half duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 2 to be a half duplex (two wires) RS-485 port.
> -
> -config ETRAX_SERIAL_PORT2_TYPE_485FD
> -       bool "Ser2 is a full duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 2 to be a full duplex (four wires) RS-485 port.
> -endchoice
> -
> -
> -config ETRAX_SER2_DTR_BIT
> -       string "Ser 2 DTR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT2
> -
> -config ETRAX_SER2_RI_BIT
> -       string "Ser 2 RI bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT2
> -
> -config ETRAX_SER2_DSR_BIT
> -       string "Ser 2 DSR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT2
> -
> -config ETRAX_SER2_CD_BIT
> -       string "Ser 2 CD bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT2
> -
>  config ETRAX_SERIAL_PORT3
>         bool "Serial port 3 enabled"
>         depends on ETRAXFS_SERIAL
>         help
>           Enables the ETRAX FS serial driver for ser3 (ttyS3).
> 
> -choice
> -       prompt "Ser3 default port type"
> -       depends on ETRAX_SERIAL_PORT3
> -       default ETRAX_SERIAL_PORT3_TYPE_232
> -       help
> -         What DMA channel to use for ser3.
> -
> -config ETRAX_SERIAL_PORT3_TYPE_232
> -       bool "Ser3 is a RS-232 port"
> -       help
> -         Configure serial port 3 to be a RS-232 port.
> -
> -config ETRAX_SERIAL_PORT3_TYPE_485HD
> -       bool "Ser3 is a half duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 3 to be a half duplex (two wires) RS-485 port.
> -
> -config ETRAX_SERIAL_PORT3_TYPE_485FD
> -       bool "Ser3 is a full duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 3 to be a full duplex (four wires) RS-485 port.
> -endchoice
> -
> -config ETRAX_SER3_DTR_BIT
> -       string "Ser 3 DTR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT3
> -
> -config ETRAX_SER3_RI_BIT
> -       string "Ser 3 RI bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT3
> -
> -config ETRAX_SER3_DSR_BIT
> -       string "Ser 3 DSR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT3
> -
> -config ETRAX_SER3_CD_BIT
> -       string "Ser 3 CD bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT3
> -
>  config ETRAX_SERIAL_PORT4
>         bool "Serial port 4 enabled"
>         depends on ETRAXFS_SERIAL && CRIS_MACH_ARTPEC3
>         help
>           Enables the ETRAX FS serial driver for ser4 (ttyS4).
> 
> -choice
> -       prompt "Ser4 default port type"
> -       depends on ETRAX_SERIAL_PORT4
> -       default ETRAX_SERIAL_PORT4_TYPE_232
> -       help
> -         What DMA channel to use for ser4.
> -
> -config ETRAX_SERIAL_PORT4_TYPE_232
> -       bool "Ser4 is a RS-232 port"
> -       help
> -         Configure serial port 4 to be a RS-232 port.
> -
> -config ETRAX_SERIAL_PORT4_TYPE_485HD
> -       bool "Ser4 is a half duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 4 to be a half duplex (two wires) RS-485 port.
> -
> -config ETRAX_SERIAL_PORT4_TYPE_485FD
> -       bool "Ser4 is a full duplex RS-485 port"
> -       depends on ETRAX_RS485
> -       help
> -         Configure serial port 4 to be a full duplex (four wires) RS-485 port.
> -endchoice
> -
> -choice
> -       prompt "Ser4 DMA in channel "
> -       depends on ETRAX_SERIAL_PORT4
> -       default ETRAX_SERIAL_PORT4_NO_DMA_IN
> -       help
> -         What DMA channel to use for ser4.
> -
> -
> -config ETRAX_SERIAL_PORT4_NO_DMA_IN
> -       bool "Ser4 uses no DMA for input"
> -       help
> -         Do not use DMA for ser4 input.
> -
> -config ETRAX_SERIAL_PORT4_DMA9_IN
> -       bool "Ser4 uses DMA9 for input"
> -       depends on ETRAX_SERIAL_PORT4
> -       help
> -         Enables the DMA9 input channel for ser4 (ttyS4).
> -         If you do not enable DMA, an interrupt for each character will be
> -         used when receiving data.
> -         Normally you want to use DMA, unless you use the DMA channel for
> -         something else.
> -
> -endchoice
> -
> -config ETRAX_SER4_DTR_BIT
> -       string "Ser 4 DTR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT4
> -
> -config ETRAX_SER4_RI_BIT
> -       string "Ser 4 RI bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT4
> -
> -config ETRAX_SER4_DSR_BIT
> -       string "Ser 4 DSR bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT4
> -
> -config ETRAX_SER4_CD_BIT
> -       string "Ser 4 CD bit (empty = not used)"
> -       depends on ETRAX_SERIAL_PORT4
> -
>  config ETRAX_SYNCHRONOUS_SERIAL
>         bool "Synchronous serial-port support"
>         depends on ETRAX_ARCH_V32
> @@ -708,32 +427,6 @@ config ETRAX_SPI_SSER0
>           want to build it as a module, which will be named spi_crisv32_sser.
>           (You need to select MMC separately.)
> 
> -config ETRAX_SPI_SSER0_DMA
> -       bool "DMA for SPI on sser0 enabled"
> -       depends on ETRAX_SPI_SSER0
> -       depends on !ETRAX_SERIAL_PORT1_DMA4_OUT && !ETRAX_SERIAL_PORT1_DMA5_IN
> -       default y
> -       help
> -         Say Y if using DMA (dma4/dma5) for SPI on synchronous serial port 0.
> -
> -config ETRAX_SPI_MMC_CD_SSER0_PIN
> -       string "MMC/SD card detect pin for SPI on sser0"
> -       depends on ETRAX_SPI_SSER0 && MMC_SPI
> -       default "pd11"
> -       help
> -         The pin to use for SD/MMC card detect.  This pin should be pulled up
> -         and grounded when a card is present.  If defined as " " (space), no
> -         pin is selected.  A card must then always be inserted for proper
> -         action.
> -
> -config ETRAX_SPI_MMC_WP_SSER0_PIN
> -       string "MMC/SD card write-protect pin for SPI on sser0"
> -       depends on ETRAX_SPI_SSER0 && MMC_SPI
> -       default "pd10"
> -       help
> -         The pin to use for the SD/MMC write-protect signal for a memory
> -         card.  If defined as " " (space), the card is considered writable.
> -
>  config ETRAX_SPI_SSER1
>         tristate "SPI using synchronous serial port 1 (sser1)"
>         depends on ETRAX_SPI_MMC
> @@ -747,32 +440,6 @@ config ETRAX_SPI_SSER1
>           want to build it as a module, which will be named spi_crisv32_sser.
>           (You need to select MMC separately.)
> 
> -config ETRAX_SPI_SSER1_DMA
> -       bool "DMA for SPI on sser1 enabled"
> -       depends on ETRAX_SPI_SSER1 && !ETRAX_ETHERNET_IFACE1
> -       depends on !ETRAX_SERIAL_PORT0_DMA6_OUT && !ETRAX_SERIAL_PORT0_DMA7_IN
> -       default y
> -       help
> -         Say Y if using DMA (dma6/dma7) for SPI on synchronous serial port 1.
> -
> -config ETRAX_SPI_MMC_CD_SSER1_PIN
> -       string "MMC/SD card detect pin for SPI on sser1"
> -       depends on ETRAX_SPI_SSER1 && MMC_SPI
> -       default "pd12"
> -       help
> -         The pin to use for SD/MMC card detect.  This pin should be pulled up
> -         and grounded when a card is present.  If defined as " " (space), no
> -         pin is selected.  A card must then always be inserted for proper
> -         action.
> -
> -config ETRAX_SPI_MMC_WP_SSER1_PIN
> -       string "MMC/SD card write-protect pin for SPI on sser1"
> -       depends on ETRAX_SPI_SSER1 && MMC_SPI
> -       default "pd9"
> -       help
> -         The pin to use for the SD/MMC write-protect signal for a memory
> -         card.  If defined as " " (space), the card is considered writable.
> -
>  config ETRAX_SPI_GPIO
>         tristate "Bitbanged SPI using gpio pins"
>         depends on ETRAX_SPI_MMC
> @@ -787,53 +454,6 @@ config ETRAX_SPI_GPIO
>           Say m to build it as a module, which will be called spi_crisv32_gpio.
>           (You need to select MMC separately.)
> 
> -# The default match that of sser0, only because that's how it was tested.
> -config ETRAX_SPI_CS_PIN
> -       string "SPI chip select pin"
> -       depends on ETRAX_SPI_GPIO
> -       default "pc3"
> -       help
> -         The pin to use for SPI chip select.
> -
> -config ETRAX_SPI_CLK_PIN
> -       string "SPI clock pin"
> -       depends on ETRAX_SPI_GPIO
> -       default "pc1"
> -       help
> -         The pin to use for the SPI clock.
> -
> -config ETRAX_SPI_DATAIN_PIN
> -       string "SPI MISO (data in) pin"
> -       depends on ETRAX_SPI_GPIO
> -       default "pc16"
> -       help
> -         The pin to use for SPI data in from the device.
> -
> -config ETRAX_SPI_DATAOUT_PIN
> -       string "SPI MOSI (data out) pin"
> -       depends on ETRAX_SPI_GPIO
> -       default "pc0"
> -       help
> -         The pin to use for SPI data out to the device.
> -
> -config ETRAX_SPI_MMC_CD_GPIO_PIN
> -       string "MMC/SD card detect pin for SPI using gpio (space for none)"
> -       depends on ETRAX_SPI_GPIO && MMC_SPI
> -       default "pd11"
> -       help
> -         The pin to use for SD/MMC card detect.  This pin should be pulled up
> -         and grounded when a card is present.  If defined as " " (space), no
> -         pin is selected.  A card must then always be inserted for proper
> -         action.
> -
> -config ETRAX_SPI_MMC_WP_GPIO_PIN
> -       string "MMC/SD card write-protect pin for SPI using gpio (space for none)"
> -       depends on ETRAX_SPI_GPIO && MMC_SPI
> -       default "pd10"
> -       help
> -         The pin to use for the SD/MMC write-protect signal for a memory
> -         card.  If defined as " " (space), the card is considered writable.
> -
>  # Avoid choices causing non-working configs by conditionalizing the inclusion.
>  if ETRAX_SPI_MMC
>  source drivers/spi/Kconfig
> diff --git a/arch/cris/arch-v32/mach-a3/Kconfig b/arch/cris/arch-v32/mach-a3/Kconfig
> index 7796aaf..8754727 100644
> --- a/arch/cris/arch-v32/mach-a3/Kconfig
> +++ b/arch/cris/arch-v32/mach-a3/Kconfig
> @@ -15,10 +15,6 @@ config ETRAX_SERIAL_PORTS
>         int
>         default 5
> 
> -config ETRAX_DDR
> -       bool
> -       default y
> -
>  config ETRAX_DDR2_MRS
>         hex "DDR2 MRS"
>         default "0"
> --
> 1.7.4.4
> 
> 
> 
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
