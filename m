Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2IGUhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:37:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53349 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2IGUh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <1345496512-11780-2-git-send-email-corentin.chary@gmail.com>
References: <1345496512-11780-1-git-send-email-corentin.chary@gmail.com>
	<1345496512-11780-2-git-send-email-corentin.chary@gmail.com>
Date: Fri, 7 Sep 2012 21:37:28 +0100
Message-ID: <CAHR064ge_itmJvdAzeLwXgA6v_zifMya+-QjC9B0-i32riPauA@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers-platform-x86: remove useless #ifdef CONFIG_ACPI_VIDEO
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>, Joey Lee <jlee@novell.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:01 PM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
> ---
>  drivers/platform/x86/acer-wmi.c       |    2 --
>  drivers/platform/x86/apple-gmux.c     |    4 ----
>  drivers/platform/x86/asus-wmi.c       |    4 ----
>  drivers/platform/x86/samsung-laptop.c |    4 ----
>  4 files changed, 14 deletions(-)
>
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index 3782e1c..934d861 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -2196,10 +2196,8 @@ static int __init acer_wmi_init(void)
>                 interface->capability &= ~ACER_CAP_BRIGHTNESS;
>                 pr_info("Brightness must be controlled by acpi video driver\n");
>         } else {
> -#ifdef CONFIG_ACPI_VIDEO
>                 pr_info("Disabling ACPI video driver\n");
>                 acpi_video_unregister();
> -#endif
>         }
>
>         if (wmi_has_guid(WMID_GUID3)) {
> diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
> index dfb1a92..dca31ce 100644
> --- a/drivers/platform/x86/apple-gmux.c
> +++ b/drivers/platform/x86/apple-gmux.c
> @@ -505,9 +505,7 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
>          * Disable the other backlight choices.
>          */
>         acpi_video_dmi_promote_vendor();
> -#if defined (CONFIG_ACPI_VIDEO) || defined (CONFIG_ACPI_VIDEO_MODULE)
>         acpi_video_unregister();
> -#endif
>         apple_bl_unregister();
>
>         gmux_data->power_state = VGA_SWITCHEROO_ON;
> @@ -593,9 +591,7 @@ static void __devexit gmux_remove(struct pnp_dev *pnp)
>         kfree(gmux_data);
>
>         acpi_video_dmi_demote_vendor();
> -#if defined (CONFIG_ACPI_VIDEO) || defined (CONFIG_ACPI_VIDEO_MODULE)
>         acpi_video_register();
> -#endif
>         apple_bl_register();
>  }
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 6a91a0c..912ec7d 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -47,9 +47,7 @@
>  #include <linux/thermal.h>
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
> -#ifdef CONFIG_ACPI_VIDEO
>  #include <acpi/video.h>
> -#endif
>
>  #include "asus-wmi.h"
>
> @@ -1780,10 +1778,8 @@ static int asus_wmi_add(struct platform_device *pdev)
>         if (asus->driver->quirks->wmi_backlight_power)
>                 acpi_video_dmi_promote_vendor();
>         if (!acpi_video_backlight_support()) {
> -#ifdef CONFIG_ACPI_VIDEO
>                 pr_info("Disabling ACPI video driver\n");
>                 acpi_video_unregister();
> -#endif
>                 err = asus_wmi_backlight_init(asus);
>                 if (err && err != -ENODEV)
>                         goto fail_backlight;
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index c1ca7bc..dd90d15 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -26,9 +26,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> -#ifdef CONFIG_ACPI_VIDEO
>  #include <acpi/video.h>
> -#endif
>
>  /*
>   * This driver is needed because a number of Samsung laptops do not hook
> @@ -1558,9 +1556,7 @@ static int __init samsung_init(void)
>                 samsung->handle_backlight = false;
>         } else if (samsung->quirks->broken_acpi_video) {
>                 pr_info("Disabling ACPI video driver\n");
> -#ifdef CONFIG_ACPI_VIDEO
>                 acpi_video_unregister();
> -#endif
>         }
>  #endif
>
> --
> 1.7.9.5
>

Any news on that ? This should really be merged before the end of rcs.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
