Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1GGN4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:56:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44323 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab1GGN4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:56:37 -0400
MIME-Version: 1.0
In-Reply-To: <1309995012-5873-2-git-send-email-reimth@gmail.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
	<1309995012-5873-1-git-send-email-reimth@gmail.com>
	<1309995012-5873-2-git-send-email-reimth@gmail.com>
Date: Thu, 7 Jul 2011 09:56:36 -0400
Message-ID: <CADnq5_MnvwFWB5x0UYdkj0Upc5REK5dnQGj5K15yFH+_MbFTsg@mail.gmail.com>
Subject: Re: [PATCH 3/3] drm/radeon: Log Subsystem Vendor and Device Information
From: Alex Deucher <alexdeucher@gmail.com>
To: reimth@googlemail.com
Cc: Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Thomas Reim <rdratlos@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 7:30 PM,  <reimth@googlemail.com> wrote:
> From: Thomas Reim <rdratlos@yahoo.co.uk>
>
>    Log PCI subsystem vendor and subsystem device ID in addition to
>    PCI vendor and device ID during kernel mode initialisation. This helps
>    to better identify radeon devices of third-party vendors, e. g. for
>    bug analysis.
>
>    Tested for kernel 2.35, 2.38 and 3.0 on Asus M2A-VM HDMI board
>
> Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

> ---
>  drivers/gpu/drm/radeon/radeon_device.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 7cfaa7e..440e6ec 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -704,8 +704,9 @@ int radeon_device_init(struct radeon_device *rdev,
>        rdev->gpu_lockup = false;
>        rdev->accel_working = false;
>
> -       DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
> -               radeon_family_name[rdev->family], pdev->vendor, pdev->device);
> +       DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
> +               radeon_family_name[rdev->family], pdev->vendor, pdev->device,
> +               pdev->subsystem_vendor, pdev->subsystem_device);
>
>        /* mutex initialization are all done here so we
>         * can recall function without having locking issues */
> --
> 1.7.1
>
>
