Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2DJKvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:51:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2DJKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:51:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 1/3] tegra, serial8250: add ->handle_break() uart_port op
Date: Tue, 10 Apr 2012 10:51:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        ArndBergmannarnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>,
        linux-serial@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Nhan H Mai <nhan.h.mai@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>
References: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com> <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204101051.36541.arnd@arndb.de>
X-Provags-ID: V02:K0:OVrdQbF6hg0lxUrhzCEmDZn32FDuX4dK4ROWYVLgzaD
 SRgHpvk3O4JQ8gT3Pwxr04X8Q44mcTtlTKrjvc9EAoZLj0TIlM
 V71a/QjUFqFGlGTzvXV//XD1Ryr9QSPB7zCskZIzBucsIWXU20
 QQ152jYzFyGWy6UdhTfGGVBjUNPUnZEYW2qhgSuG2SpKMThgc0
 cu/Pn04BQY+t4xRVi9qmM86xQbF5g3zyY99wEZMrdYsEvuGCO/
 aSlbX0gkhpyeUJS4QlSvsRyT9QsNgqLZW7GBrMwEqJzLmE6bla
 D8yFpYmhRKAxJGq+yfiDdEbBbpp+piHqgSpDC7s6jh/QeJbcJH
 p6orxhXRHVIzPQAwEwhs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Dan Williams wrote:
> The "KT" serial port has another use case for a "received break" quirk,
> so before adding another special case to the 8250 core take this
> opportunity to push such quirks out of the core and into a uart_port op.
> 
> Stephen says:
> "If the callback function is to no longer live in 8250.c itself,
>  arch/arm/mach-tegra/devices.c isn't logically a good place to put it,
>  and that file will be going away once we get rid of all the board files
>  and move solely to device tree."
> 
> ...so since 8250_pci.c houses all the quirks for pci serial devices this
> quirk is similarly housed in of_serial.c.  Once the open firmware
> conversion completes the infrastructure details (CONFIG_TEGRA_SERIAL,
> include/linux/of_serial.h, and the export) can all be removed to make
> this self contained to of_serial.c.

Looks much better to me, thanks!

Acked-by: Arnd Bergmann <arnd@arndb.de>

> @@ -81,7 +83,9 @@ static struct platform_device trimslice_audio_device = {
>  };
>  
>  static struct platform_device *trimslice_devices[] __initdata = {
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
>  	&debug_uart,
> +#endif
>  	&tegra_sdhci_device1,
>  	&tegra_sdhci_device4,
>  	&tegra_i2s_device1,

FWIW, I'd prefer to see this without the #if, I generally think the devices
that are present should not depend on the drivers that are built into the
kernel. However, since this code is going away soon, I don't care all that
much about it.

	Arnd
