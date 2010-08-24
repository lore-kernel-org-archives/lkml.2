Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0HXOUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:20:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41424 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0HXOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:20:34 -0400
Date: Tue, 24 Aug 2010 15:20:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joey Lee <jlee@novell.com>
Cc: trenn@suse.de, gregkh@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis.Jansen@web.de
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
	detect
Message-ID: <20100824142026.GA16200@srcf.ucam.org>
References: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 04:08:59AM -0600, Joey Lee wrote:
>  drivers/gpu/Makefile       |    2 +-
>  drivers/gpu/stub/Kconfig   |   13 +++++++++++++
>  drivers/gpu/stub/Makefile  |    1 +
>  drivers/gpu/stub/poulsbo.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/video/Kconfig      |    2 ++
>  5 files changed, 61 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/gpu/stub/Kconfig
>  create mode 100644 drivers/gpu/stub/Makefile
>  create mode 100644 drivers/gpu/stub/poulsbo.c
> 
> diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
> index 30879df..cc92778 100644
> --- a/drivers/gpu/Makefile
> +++ b/drivers/gpu/Makefile
> @@ -1 +1 @@
> -obj-y			+= drm/ vga/
> +obj-y			+= drm/ vga/ stub/
> diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
> new file mode 100644
> index 0000000..88fd919
> --- /dev/null
> +++ b/drivers/gpu/stub/Kconfig
> @@ -0,0 +1,13 @@
> +config STUB_POULSBO
> +	tristate "Intel Poulsbo Stub Driver"
> +        default m
> +        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> +        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
> +        select ACPI_VIDEO if ACPI
> +	help
> +	  Choose this option if you have a system that has Intel Poulsbo
> +	  integrated graphics. If M is selected, the module will be called
> +	  Poulsbo. This driver is a stub driver for Poulsbo that will call

Really? I suspect it'll be called poulsbo.ko :)

> +static int __init poulsbo_init(void)
> +{
> +	printk(KERN_INFO "poulsbo: stub driver load.\n");

Don't really need to printk here

> +	return acpi_video_register();
> +}
> +
> +static void __exit poulsbo_cleanup(void)
> +{
> +	acpi_video_unregister();
> +	printk(KERN_INFO "poulsbo: stub driver unloaded.\n");

Or here - we'll get the ACPI video output. Other than that, looks good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
