Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab2EPMMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:12:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60817 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2EPMMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:12:42 -0400
Date: Wed, 16 May 2012 05:12:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sonic.zhang@analog.com
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver
 for BF60x family processors.
Message-ID: <20120516121237.GC31261@kroah.com>
References: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 04:26:07PM +0800, sonic.zhang@analog.com wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> The CRC peripheral is a hardware block used to compute the CRC of the block
> of data. This is based on a CRC32 engine which computes the CRC value of 32b
> data words presented to it. For data words of < 32b in size, it is the
> responsibility of the application to pack the data into 32b data units.
> 
> This driver defines data strcture crc_info and 4 IOCTL interfaces for applciations.
> 1) CRC Memory Scan
> 2) CRC Memory Transfer
> 3) CRC Data Verify
> 4) CRC Data Fill
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/char/Kconfig    |    8 +
>  drivers/char/Makefile   |    1 +
>  drivers/char/bfin_crc.c |  537 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 546 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/bfin_crc.c

Why is this a char driver, and not a crypto driver, using the existing
crypto userspace api for things like this?

> diff --git a/drivers/char/bfin_crc.c b/drivers/char/bfin_crc.c
> new file mode 100644
> index 0000000..3f7d1d8
> --- /dev/null
> +++ b/drivers/char/bfin_crc.c
> @@ -0,0 +1,537 @@
> +/*
> + * Blackfin On-Chip hardware CRC Driver
> + *
> + * Copyright 2011 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2 or later.

Do you really mean "or later"?  It's fine if you do, just checking.

thanks,

greg k-h
