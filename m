Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0K3T5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:57:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41756 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0K3T5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:57:35 -0500
Date: Tue, 30 Nov 2010 11:57:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Sin <davidsin@ti.com>
Cc: Greg KH <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lajos Molnar <molnar@ti.com>
Subject: Re: [RFC v2 7/8] TILER-DMM: Main TILER driver implementation
Message-Id: <20101130115710.841c7857.randy.dunlap@oracle.com>
In-Reply-To: <1291147139-23472-8-git-send-email-davidsin@ti.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
	<1291147139-23472-8-git-send-email-davidsin@ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 13:58:58 -0600 David Sin wrote:

> From: Lajos Molnar <molnar@ti.com>
> 
> This patch contains the TILER driver and implementation of the TILER
> block manipulation and mapping functions.
> 
> It also contains the makefile and config file for the TILER driver.
> 
> Signed-off-by: Lajos Molnar <molnar@ti.com>
> Signed-off-by: David Sin <davidsin@ti.com>
> ---
>  arch/arm/mach-omap2/Makefile     |    1 +
>  drivers/misc/tiler/Kconfig       |   72 +++++++
>  drivers/misc/tiler/Makefile      |    7 +
>  drivers/misc/tiler/tiler-iface.c |   66 ++++++
>  drivers/misc/tiler/tiler-main.c  |  405 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 551 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/tiler/Kconfig
>  create mode 100644 drivers/misc/tiler/Makefile
>  create mode 100644 drivers/misc/tiler/tiler-iface.c
>  create mode 100644 drivers/misc/tiler/tiler-main.c


> diff --git a/drivers/misc/tiler/Kconfig b/drivers/misc/tiler/Kconfig
> new file mode 100644
> index 0000000..9b8bfed
> --- /dev/null
> +++ b/drivers/misc/tiler/Kconfig
> @@ -0,0 +1,72 @@
> +config HAVE_TI_DMM
> +	bool
> +	default y
> +	depends on ARCH_OMAP4
> +
> +menuconfig TI_DMM
> +        tristate "TI DMM support"
> +        default y
> +        depends on HAVE_TI_DMM
> +        help
> +           DMM driver for TI chips.
> +
> +menuconfig TI_TILER
> +        tristate "TI TILER support"
> +        default y
> +        depends on TI_DMM
> +        help
> +           TILER driver for TI chips.  The TI TILER device
> +           enables video rotation on certain TI chips such as OMAP4 or
> +           TI816x.  Video rotation will be limited without TILER support.
> +
> +config TILER_GRANULARITY
> +        int "Allocation granularity (2^n)"

Having (2^n) in the prompt makes me think that the value set here is "n",
but that's not the case.  I suggest removing (2^n) here...


> +        range 1 4096
> +        default 128
> +        depends on TI_TILER
> +        help
> +           This option sets the default TILER allocation granularity.  It can
> +           be overriden by the tiler.grain boot argument.
> +
> +           The allocation granularity is the smallest TILER block size (in
> +           bytes) managed distinctly by the TILER driver.  TILER blocks of any
> +           size are managed in chunks of at least this size.
> +
> +           Must be a 2^n in the range of 1 to 4096; however, the TILER driver

and changing 2^n here to just say:

	  Must be a power of 2 in the range of 1 to 4096; however, ...

and then same 2 comments again repeated below.


> +           may use a larger supported granularity.
> +
> +           Supported values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024,
> +           2048, 4096.
> +
> +config TILER_ALIGNMENT
> +        int "Allocation alignment (2^n)"
> +        range 1 4096
> +        default 4096
> +        depends on TI_TILER
> +        help
> +           This option sets the default TILER allocation alignment.  It can
> +           be overriden by the tiler.align boot argument.
> +
> +           Must be a 2^n in the range of 1 to 4096; however, it is naturally
> +           aligned to the TILER granularity.
> +
> +           Supported values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024,
> +           2048, 4096.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
