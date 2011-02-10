Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1BJCKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:10:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:25340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1BJCKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:10:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,448,1291622400"; 
   d="scan'208";a="886071655"
Subject: Re: [PATCH 1/1] Probe for output switch method when searching
 video devices.
From: Zhang Rui <rui.zhang@intel.com>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1295803354-5298-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
References: <1295803354-5298-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 10:07:19 +0800
Message-ID: <1297303639.14594.6.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 01:22 +0800, Michael Karcher wrote:
> This patch reverts one hunk of 677bd810eedce61edf15452491781ff046b92edc
> "ACPI video: remove output switching control", namely the removal of
> probing for _DOS/_DOD when searching for video devices.
> 
> This is needed on some Fujitsu Laptops (at least S7110, P8010) for the
> ACPI backlight interface to work, as an these machines, neither ROM nor
> posting methods are available, and after removal of output switching,
> none of the caps triggers, which prevents the backlight search from
> being entered.
> 
> Tested on a Fujitsu Lifebook S7110 and Fujitsu Lifebook P8010.
> This probably fixes https://bugzilla.kernel.org/show_bug.cgi?id=27312
> for the people who have no entry in /sys/class/backlight.
> 
> This is the complete list of public (starting with "_") methods implemented
> on the S7110, BIOS rev 1.34:
> 
> \_SB_.PCI0.GFX0._ADR
> \_SB_.PCI0.GFX0._DOS
> \_SB_.PCI0.GFX0._DOD
> \_SB_.PCI0.GFX0.CRT._ADR
> \_SB_.PCI0.GFX0.CRT._DCS
> \_SB_.PCI0.GFX0.CRT._DGS
> \_SB_.PCI0.GFX0.CRT._DSS
> \_SB_.PCI0.GFX0.LCD._ADR
> \_SB_.PCI0.GFX0.LCD._BCL
> \_SB_.PCI0.GFX0.LCD._BCM
> \_SB_.PCI0.GFX0.LCD._BQC
> \_SB_.PCI0.GFX0.LCD._DCS
> \_SB_.PCI0.GFX0.LCD._DGS
> \_SB_.PCI0.GFX0.LCD._DSS
> \_SB_.PCI0.GFX0.LCD._PS0
> \_SB_.PCI0.GFX0.LCD._PS3
> \_SB_.PCI0.GFX0.TV._ADR
> \_SB_.PCI0.GFX0.TV._DCS
> \_SB_.PCI0.GFX0.TV._DGS
> \_SB_.PCI0.GFX0.TV._DSS
> \_SB_.PCI0.GFX0.DVI._ADR
> \_SB_.PCI0.GFX0.DVI._DCS
> \_SB_.PCI0.GFX0.DVI._DGS
> \_SB_.PCI0.GFX0.DVI._DSS
> 
> Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

Acked-by: Zhang Rui <rui.zhang@intel.com>

> ---
>  drivers/acpi/video_detect.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 42d3d72..5af3479 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -82,6 +82,11 @@ long acpi_is_video_device(struct acpi_device *device)
>  	if (!device)
>  		return 0;
>  
> +	/* Is this device able to support video switching ? */
> +	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOD", &h_dummy)) ||
> +	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOS", &h_dummy)))
> +		video_caps |= ACPI_VIDEO_OUTPUT_SWITCHING;
> +
>  	/* Is this device able to retrieve a video ROM ? */
>  	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_ROM", &h_dummy)))
>  		video_caps |= ACPI_VIDEO_ROM_AVAILABLE;


