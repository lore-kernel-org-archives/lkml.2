Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1FSRUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 13:20:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1FSRUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 13:20:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 02/19] OpenRISC: Device tree
Date: Sun, 19 Jun 2011 19:19:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-3-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-3-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191919.27737.arnd@arndb.de>
X-Provags-ID: V02:K0:e16EdbpUTHK5cVSOpS6cyRog/a8eSEobWfExwHY/6Ld
 oy45MkJDja3w2Z08LYG+g3mqyquYLjin875RoDYxOuZP9KrwDO
 wx/cv/PxmJAwXBgzSW2C4Bnyv5f9rTbz4PqTmY/zh1xYv4fs8V
 K79n1rsxrYRtrLcn82GnKXbKF2ZEISS5vGDqOH0xLdixd0miz8
 jLVriAEy6HCltEVYQtWqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:28 Jonas Bonn wrote:
> 
> The OpenRISC architecture uses the device tree infrastructure for the
> platform description.  This is currently limited to having a device tree
> built into the kernel, but work is underway within the OpenRISC project
> to define how this device tree blob should be passed into the kernel from
> an external resource.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>

Best take devicetree-discuss@lists.ozlabs.org when posting this again.

> ---
>  arch/openrisc/boot/dts/aac.dts    |  290 +++++++++++++++++++++++++++++++++++++
>  arch/openrisc/boot/dts/atlys.dts  |   94 ++++++++++++
>  arch/openrisc/boot/dts/system.dts |   88 +++++++++++
>  arch/openrisc/include/asm/prom.h  |   92 ++++++++++++
>  arch/openrisc/kernel/prom.c       |  109 ++++++++++++++
>  5 files changed, 673 insertions(+), 0 deletions(-)
>  create mode 100644 arch/openrisc/boot/dts/aac.dts
>  create mode 100644 arch/openrisc/boot/dts/atlys.dts
>  create mode 100644 arch/openrisc/boot/dts/system.dts
>  create mode 100644 arch/openrisc/include/asm/prom.h
>  create mode 100644 arch/openrisc/kernel/prom.c
> 
> diff --git a/arch/openrisc/boot/dts/aac.dts b/arch/openrisc/boot/dts/aac.dts
> new file mode 100644
> index 0000000..d9e724f
> --- /dev/null
> +++ b/arch/openrisc/boot/dts/aac.dts
> @@ -0,0 +1,290 @@
> +/dts-v1/;
> +/ {
> +	compatible = "orsoc,development-board";
> +	#size-cells = <1>;
> +	#address-cells = <1>;
> +
> +	chosen {
> +		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 debug";
> +/*		bootargs = "console=uart,mmio,0x90000000,115200 lpj=200000 root=/dev/nfs rw nfsroot=172.30.0.1:/home/jonas/local/opencores/linux-2.6/arch/or32/support/rootfs,rw,nolock ip=172.30.0.2::::::"; */
> +	};

I think having a hardcoded command line here is not really helpful, this
should normally be filled by the bootloader. The console settings should
probably be probed from the device tree, we have good existing bindings
for serial ports.

For the lpj value, I would also recommend passing the clock frequency
in the device tree in a generic form, so you can compute the delay
loop settings from it.

	Arnd
