Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1KUUan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:30:43 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59141 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1KUUam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:30:42 -0500
Message-ID: <1321907436.32195.25.camel@x61.thuisdomein>
Subject: Re: [RFCv1 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory
 Drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com
Date: Mon, 21 Nov 2011 21:30:36 +0100
In-Reply-To: <1321883764-1958-9-git-send-email-sjur.brandeland@stericsson.com>
References: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1321883764-1958-9-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few minor comments follow.

On Mon, 2011-11-21 at 14:56 +0100, Sjur Brændeland wrote:
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  drivers/Kconfig       |    2 ++
>  drivers/Makefile      |    1 +
>  drivers/xshm/Kconfig  |   10 ++++++++++
>  drivers/xshm/Makefile |    4 ++++
>  4 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xshm/Kconfig
>  create mode 100644 drivers/xshm/Makefile
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index b5e6f24..c91a13c 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -136,4 +136,6 @@ source "drivers/hv/Kconfig"
>  
>  source "drivers/devfreq/Kconfig"
>  
> +source "drivers/xshm/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 1b31421..eedd8e5 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -120,6 +120,7 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
>  obj-$(CONFIG_STAGING)		+= staging/
>  obj-y				+= platform/
>  obj-y				+= ieee802154/
> +obj-$(CONFIG_XSHM)		+= xshm/
>  #common clk code
>  obj-y				+= clk/
>  
> diff --git a/drivers/xshm/Kconfig b/drivers/xshm/Kconfig
> new file mode 100644
> index 0000000..fa627b8
> --- /dev/null
> +++ b/drivers/xshm/Kconfig
> @@ -0,0 +1,10 @@
> +config XSHM
> +	tristate "External Shared Memory Protocol (XSHM)"
> +#	depends on GENIO

Why is this added commented out?

> +	default n
> +	---help---
> +	Say "yes" if you want to support External Shared Memory (XSHM)

"Say Y"?

> +	IPC mechanism. XSHM is an IPC protocol used to talk to external
> +	device such as modem over a shared memory (e.g. Chip to Chip).
> +	This will normally be built-in, loadable module is used for testing.

Perhaps something like: "Only say M here if you want to test XSHM and
need to load and unload its module."?

> +	If unsure say N.
> diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
> new file mode 100644
> index 0000000..a630501
> --- /dev/null
> +++ b/drivers/xshm/Makefile
> @@ -0,0 +1,4 @@
> +obj-$(CONFIG_XSHM) +=  xshmchr.o
> +xshmchr-objs := xshm_chr.o

A quick scan of the other patches didn't show a file named xshmchr.c. If
that's correct, can't you rename either the object or the source file? 

> +obj-$(CONFIG_XSHM) += xshm.o
> +xshm-objs := xshm_boot.o xshm_pdev.o genio_dummy.o

Are these two separate drivers (modules) that both are built if one
Kconfig symbol is set? If so, is there a reason why you can't use either
one combined driver or two Kconfig symbols?


Paul Bolle

