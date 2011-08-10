Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1HJVZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:25:39 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:44736 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755071Ab1HJVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:25:37 -0400
Date: Wed, 10 Aug 2011 14:25:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dri-devel@lists.freedesktop.org,
        akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH -next] drm: fix kconfig unmet dependency warning
Message-Id: <20110810142534.684f1e31.rdunlap@xenotime.net>
In-Reply-To: <20110810142401.c0a4a041.rdunlap@xenotime.net>
References: <20110810142702.da4f1b9ff86ddbedc3c73a48@canb.auug.org.au>
	<20110810142401.c0a4a041.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 14:24:01 -0700 Randy Dunlap wrote:

Sorry, this applies to mainline, not linux-next.


> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix kconfig unmet dependency warning.  BACKLIGHT_CLASS_DEVICE depends on
> BACKLIGHT_LCD_SUPPORT, so select the latter along with the former.
> 
> warning: (DRM_RADEON_KMS && DRM_I915 && STUB_POULSBO && FB_BACKLIGHT && PANEL_SHARP_LS037V7DW01 && PANEL_ACX565AKM && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_ASUS && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/gpu/drm/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- lnx-31-rc1.orig/drivers/gpu/drm/Kconfig
> +++ lnx-31-rc1/drivers/gpu/drm/Kconfig
> @@ -96,6 +96,7 @@ config DRM_I915
>  	select FB_CFB_IMAGEBLIT
>  	# i915 depends on ACPI_VIDEO when ACPI is enabled
>  	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
> +	select BACKLIGHT_LCD_SUPPORT if ACPI
>  	select BACKLIGHT_CLASS_DEVICE if ACPI
>  	select VIDEO_OUTPUT_CONTROL if ACPI
>  	select INPUT if ACPI
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
