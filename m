Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1LGM5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:57:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52494 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1LGM5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:57:18 -0500
MIME-Version: 1.0
In-Reply-To: <1323250088-1729-9-git-send-email-sjur.brandeland@stericsson.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
	<1323250088-1729-9-git-send-email-sjur.brandeland@stericsson.com>
Date: Wed, 7 Dec 2011 13:57:17 +0100
Message-ID: <CACRpkda7Bm2QY2dFs-xctOgFdVeL0YH-rOepxYHnZhXE-xu0zQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/7 Sjur Brændeland <sjur.brandeland@stericsson.com>:

Some commit blurb here pls.

> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
(...)
> diff --git a/drivers/xshm/Kconfig b/drivers/xshm/Kconfig
> new file mode 100644
> index 0000000..80daca4
> --- /dev/null
> +++ b/drivers/xshm/Kconfig
> @@ -0,0 +1,17 @@
> +# XSHM gets selected by whoever wants it.
> +config XSHM
> +       depends on CONFIG_C2C
> +       tristate
> +
> +config XSHM_CHR
> +       tristate "Character device for External Shared Memory (XSHM)"
> +       select XSHM
> +       default n
> +       ---help---
> +       Say "Y" to use a character device for the External Shared
> +       Memory (XSHM) IPC mechanism. XSHM is an IPC protocol used to
> +       talk to external device such as modem over a shared memory
> +       (e.g. Chip to Chip).
> +       Only say "M" here if you want to test XSHM and need to load
> +       and unload its module.
> +       If unsure say N.

As mentioned this needs some Kconfig entry to enable the
dummy driver.

This will appear right in the root menu of the driver config,
and I think it is more apropriate to hide this from systems that
do not have xshm, so check for how I did in drivers/pinctrl for
example like this:

config XSHM
        bool
        depends on EXPERIMENTAL

if XSHM

menu "XSHM drivers and interfaces"
        depends on XSHM

... your previous entries here ...

endmenu

endif

This will hide everything until an arch issues
select XSHM in it's say arch/arm/mach-foo/Kconfig.

> diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
> new file mode 100644
> index 0000000..954bd22
> --- /dev/null
> +++ b/drivers/xshm/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_XSHM) += xshm.o
> +xshm-objs := xshm_boot.o xshm_dev.o
> +obj-$(CONFIG_XSHM_CHR) +=  xshm_chr.o

Also include a build rule for the dummy driver here.

Thanks,
Linus Walleij
