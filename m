Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1C1TWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:22:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1C1TWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:22:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] acpi: Remove sysfs_create_link from video driver
Date: Mon, 28 Mar 2011 21:22:21 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeff.chua.linux@gmail.com
References: <1301316362-2955-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1301316362-2955-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103282122.21175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 28, 2011, Matthew Garrett wrote:
> The acpi video driver attempts to explicitly create a sysfs link between
> the acpi device and the associated PCI device. However, we're now also
> doing this from the backlight core, which means that we get a backtrace
> caused by a duplicate file. Remove the code and leave it up to the
> backlight core.
> 
> Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/video.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index a18e497..31e9e10 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -824,11 +824,6 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
>  		device->backlight->props.brightness =
>  				acpi_video_get_brightness(device->backlight);
>  
> -		result = sysfs_create_link(&device->backlight->dev.kobj,
> -					   &device->dev->dev.kobj, "device");
> -		if (result)
> -			printk(KERN_ERR PREFIX "Create sysfs link\n");
> -
>  		device->cooling_dev = thermal_cooling_device_register("LCD",
>  					device->dev, &video_cooling_ops);
>  		if (IS_ERR(device->cooling_dev)) {
> @@ -1381,7 +1376,6 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
>  		       "Cant remove video notify handler\n");
>  	}
>  	if (device->backlight) {
> -		sysfs_remove_link(&device->backlight->dev.kobj, "device");
>  		backlight_device_unregister(device->backlight);
>  		device->backlight = NULL;
>  	}
> 

