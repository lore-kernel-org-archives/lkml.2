Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1JRMNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:13:42 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:43146 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab1JRMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:13:41 -0400
Message-ID: <4E9D6C05.9040106@snapgear.com>
Date: Tue, 18 Oct 2011 22:07:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/21 v2] m68k: drop unused Kconfig symbols
References: <1318925407.6414.22.camel@x61.thuisdomein>
In-Reply-To: <1318925407.6414.22.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 10/18/2011 06:10 PM, Paul Bolle wrote:
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> 0) Still only "git grep" tested.
>
> 1) New in v2:
> - redone for linux-next master
> - dropped a few "select EMAC_INC" and "select HW_FEITH" lines that
>    weren't in current mainline
> - dropped SOM5282EM too (discovered this while doing this second
>    version, my scripts aren't smart enough too catch it)

Hmm. I don't want to lose the SOM5282EM config option. Although it
isn't used inside the code it does let the configurer know that this
specific board is supported.

Regards
Greg


>   arch/m68k/Kconfig.devices |   28 +------------------------
>   arch/m68k/Kconfig.machine |   50 ---------------------------------------------
>   2 files changed, 1 insertions(+), 77 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
> index d964dc4..dbff941 100644
> --- a/arch/m68k/Kconfig.devices
> +++ b/arch/m68k/Kconfig.devices
> @@ -77,32 +77,6 @@ config MULTIFACE_III_TTY
>
>   	  To compile this driver as a module, choose M here.
>
> -config GVPIOEXT
> -	tristate "GVP IO-Extender support"
> -	depends on PARPORT=n&&  ZORRO
> -	help
> -	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
> -	  Otherwise, say N.
> -
> -config GVPIOEXT_LP
> -	tristate "GVP IO-Extender parallel printer support"
> -	depends on GVPIOEXT
> -	help
> -	  Say Y to enable driving a printer from the parallel port on your
> -	  GVP IO-Extender card, N otherwise.
> -
> -config GVPIOEXT_PLIP
> -	tristate "GVP IO-Extender PLIP support"
> -	depends on GVPIOEXT
> -	help
> -	  Say Y to enable doing IP over the parallel port on your GVP
> -	  IO-Extender card, N otherwise.
> -
> -config MAC_HID
> -	bool
> -	depends on INPUT_ADBHID
> -	default y
> -
>   config HPDCA
>   	tristate "HP DCA serial support"
>   	depends on DIO&&  SERIAL_8250
> @@ -145,7 +119,7 @@ config DN_SERIAL
>
>   config SERIAL_CONSOLE
>   	bool "Support for serial port console"
> -	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO)&&  (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
> +	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO)&&  (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
>   	---help---
>   	  If you say Y here, it will be possible to use a serial port as the
>   	  system console (the system console is the device which receives all
> diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
> index 7d5c20b..c19b514 100644
> --- a/arch/m68k/Kconfig.machine
> +++ b/arch/m68k/Kconfig.machine
> @@ -303,16 +303,6 @@ config COBRA5282
>   	help
>   	  Support for the senTec COBRA5282 board.
>
> -config EMAC_INC
> -	bool
> -
> -config SOM5282EM
> -	bool "EMAC.Inc SOM5282EM board support"
> -	depends on M528x
> -	select EMAC_INC
> -	help
> -	  Support for the EMAC.Inc SOM5282EM module.
> -
>   config WILDFIRE
>   	bool "Intec Automation Inc. WildFire board support"
>   	depends on M528x
> @@ -371,27 +361,21 @@ config FIREBEE
>   	help
>   	  Support for the FireBee ColdFire 5475 based board.
>
> -config HW_FEITH
> -	bool
> -
>   config CLEOPATRA
>   	bool "Feith CLEOPATRA board support"
>   	depends on (M5307 || M5407)
> -	select HW_FEITH
>   	help
>   	  Support for the Feith Cleopatra boards.
>
>   config CANCam
>   	bool "Feith CANCam board support"
>   	depends on M5272
> -	select HW_FEITH
>   	help
>   	  Support for the Feith CANCam board.
>
>   config SCALES
>   	bool "Feith SCALES board support"
>   	depends on M5272
> -	select HW_FEITH
>   	help
>   	  Support for the Feith SCALES board.
>
> @@ -438,13 +422,6 @@ if !MMU || COLDFIRE
>
>   comment "Machine Options"
>
> -config ROMFS_FROM_ROM
> -	bool "ROMFS image not RAM resident"
> -	depends on (NETtel || SNAPGEAR)
> -	help
> -	  The ROMfs filesystem will stay resident in the FLASH/ROM, not be
> -	  moved into RAM.
> -
>   config UBOOT
>   	bool "Support for U-Boot command line parameters"
>   	help
> @@ -524,33 +501,6 @@ config KERNELBASE
>   	  a system with the RAM based at address 0, and leaving enough room
>   	  for the theoretical maximum number of 256 vectors.
>
> -choice
> -	prompt "RAM bus width"
> -	default RAMAUTOBIT
> -
> -config RAMAUTOBIT
> -	bool "AUTO"
> -	help
> -	  Select the physical RAM data bus size. Not needed on most platforms,
> -	  so you can generally choose AUTO.
> -
> -config RAM8BIT
> -	bool "8bit"
> -	help
> -	  Configure RAM bus to be 8 bits wide.
> -
> -config RAM16BIT
> -	bool "16bit"
> -	help
> -	  Configure RAM bus to be 16 bits wide.
> -
> -config RAM32BIT
> -	bool "32bit"
> -	help
> -	  Configure RAM bus to be 32 bits wide.
> -
> -endchoice
> -
>   comment "ROM configuration"
>
>   config ROM


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
