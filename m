Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1JZAWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:22:19 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:26917 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1JZAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:22:18 -0400
Message-ID: <4EA752D8.3040603@snapgear.com>
Date: Wed, 26 Oct 2011 10:22:48 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Revive lost ARAnyM config options
References: <1319573128-21127-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1319573128-21127-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 26/10/11 06:05, Geert Uytterhoeven wrote:
> commit 0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig
> options to improve mmu/non-mmu selections") accidentally dropped the ARAnyM
> config options. Re-add them to the "Platform devices" section.

Sorry, my fault.


> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


>   arch/m68k/Kconfig.devices |   31 +++++++++++++++++++++++++++++++
>   1 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
> index 82ddb93..5cf1c54 100644
> --- a/arch/m68k/Kconfig.devices
> +++ b/arch/m68k/Kconfig.devices
> @@ -24,6 +24,37 @@ config PROC_HARDWARE
>   	  including the model, CPU, MMU, clock speed, BogoMIPS rating,
>   	  and memory size.
>
> +config NATFEAT
> +	bool "ARAnyM emulator support"
> +	depends on ATARI
> +	help
> +	  This option enables support for ARAnyM native features, such as
> +	  access to a disk image as /dev/hda.
> +
> +config NFBLOCK
> +	tristate "NatFeat block device support"
> +	depends on BLOCK&&  NATFEAT
> +	help
> +	  Say Y to include support for the ARAnyM NatFeat block device
> +	  which allows direct access to the hard drives without using
> +	  the hardware emulation.
> +
> +config NFCON
> +	tristate "NatFeat console driver"
> +	depends on NATFEAT
> +	help
> +	  Say Y to include support for the ARAnyM NatFeat console driver
> +	  which allows the console output to be redirected to the stderr
> +	  output of ARAnyM.
> +
> +config NFETH
> +	tristate "NatFeat Ethernet support"
> +	depends on ETHERNET&&  NATFEAT
> +	help
> +	  Say Y to include support for the ARAnyM NatFeat network device
> +	  which will emulate a regular ethernet device while presenting an
> +	  ethertap device to the host system.
> +
>   endmenu
>
>   menu "Character devices"


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
