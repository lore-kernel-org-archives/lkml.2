Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1CNPuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:50:40 -0400
Received: from kroah.org ([198.145.64.141]:50417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610Ab1CNPt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:49:57 -0400
Date: Mon, 14 Mar 2011 08:45:10 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 10/12] Introduce CONFIG_GOOGLE_FIRMWARE
Message-ID: <20110314154510.GE31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014347.6133.4388.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312014347.6133.4388.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 05:43:47PM -0800, Mike Waychison wrote:
> In order to keep Google's firmware drivers organized amongst themselves,
> create a new directory for them to live in.  As well, all Google
> firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which defaults
> to 'n' in the kernel build.

Everything defaults to 'n' in the kernel build system, so this really
isn't a big deal :)

> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  drivers/firmware/Kconfig         |    2 ++
>  drivers/firmware/Makefile        |    2 ++
>  drivers/firmware/google/Kconfig  |   14 ++++++++++++++
>  drivers/firmware/google/Makefile |    1 +
>  4 files changed, 19 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/firmware/google/Kconfig
>  create mode 100644 drivers/firmware/google/Makefile
> 
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index e710424..d848b26 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -134,4 +134,6 @@ config ISCSI_IBFT
>  	  detect iSCSI boot parameters dynamically during system boot, say Y.
>  	  Otherwise, say N.
>  
> +source "drivers/firmware/google/Kconfig"
> +
>  endmenu
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index 1c3c173..6f68007 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -11,3 +11,5 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
>  obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
>  obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
>  obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
> +
> +obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
> diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
> new file mode 100644
> index 0000000..7834729
> --- /dev/null
> +++ b/drivers/firmware/google/Kconfig
> @@ -0,0 +1,14 @@
> +config GOOGLE_FIRMWARE
> +	bool "Google Firmware Drivers"
> +	depends on X86
> +	default n
> +	help
> +	  These firmware drivers are used by Google's servers.  They are
> +	  only useful if you are working directly on one of their
> +	  proprietary servers or implementing similar firmware
> +	  interfaces.  If in doubt, say "N".

How about dropping the "or implementing..." part of this sentance, as
that leaves a lot open for some people to justify enabling this option
for their machines, when it really isn't true at all at this point in
time.

thanks,

greg k-h
