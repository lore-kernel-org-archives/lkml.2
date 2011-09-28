Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1I1Nbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:31:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1I1Nbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:31:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 07/24] C6X: devicetree support
Date: Wed, 28 Sep 2011 15:31:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-8-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-8-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281531.36792.arnd@arndb.de>
X-Provags-ID: V02:K0:FtWLhd8oGNv0h2ZhSjuvSdpJJrwclCMr63dBcuM985G
 0OiUd3afUtelC0wcWxuWbl7bqfsz/Q5KvSpOSqXntwZLX9q0V5
 N63sbpbpm6UMbehu4n9UvaSS6XhTrTs9NcNxNi88lRsDzh91N0
 Eu5Yd4H5dKEzd0eYGPPy7+BBoPDAbqJL7CF+HsqLE2v2FxAyUI
 NOW0h0ZxfOBApi1+hzjP/too2WVENq5GZiQ7Jz5qTlzf/GE2zt
 1707TNgeCM74rNZXCm0irZRHe6RKVmSmjj73AsW3Rz51rzRc+D
 Juu6BdgNtRxBRKRCuIRYdEOuy5OuRVhcDXP0ecHOHidM/YVgeP
 U0Y2lK0ZykjQxM53hW1A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> diff --git a/arch/c6x/boot/install-dtb.c b/arch/c6x/boot/install-dtb.c
> new file mode 100644
> index 0000000..fa979ce
> --- /dev/null
> +++ b/arch/c6x/boot/install-dtb.c
> @@ -0,0 +1,333 @@
> +/*
> + * Program to hack in a DTB to an ELF file having a placeholder
> + * section named __fst_blob.
> + *
> + * This allows for building multiple images with builtin DTBs
> + * using a single vmlinux image. This is only necessary until
> + * bootloader support exists.
> + *
> + * Copyright 2011 Texas Instruments Incorporated
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + * Usage: install-dtb <image.dtb> <kernel.elf>
> + */

Other architectures allow simply appending the device tree to the
kernel image file, which is more convenient for users and does
not require much kernel support. Have you tried this?

> diff --git a/arch/c6x/platforms/platform.c b/arch/c6x/platforms/platform.c
> new file mode 100644
> index 0000000..ad4651c
> --- /dev/null
> +++ b/arch/c6x/platforms/platform.c
> @@ -0,0 +1,17 @@
> +
> +static int __init c6x_device_probe(void)
> +{
> +       of_platform_bus_probe(NULL, of_default_bus_match_table, NULL);
> +       return 0;
> +}
> +device_initcall(c6x_device_probe);

device_initcall is run rather late. I think it would be more useful
to run this as early as possible, in order to make it possible to
have more of the core services probed through the device tree.

I also think that for probing the device tree root, you should be
using of_platform_populate instead of of_platform_bus_probe
nowadays. Maybe Grant can provide more information on this.

	Arnd
