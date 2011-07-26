Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1GZNGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:06:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40749 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1GZNGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <1311150845-19198-1-git-send-email-reimth@gmail.com>
References: <1309995012-5873-1-git-send-email-reimth@gmail.com>
	<1311150845-19198-1-git-send-email-reimth@gmail.com>
Date: Tue, 26 Jul 2011 09:05:59 -0400
Message-ID: <CADnq5_O=B7hyDV9ADP=U+vdP+hJEJQTeD9tQDTryvJiqbshDuQ@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Fix ECS A740GM-M DVI-D EDID error flooding problem
From: Alex Deucher <alexdeucher@gmail.com>
To: reimth@googlemail.com
Cc: Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Stephen Michaels <Stephen.Micheals@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <reimth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 4:34 AM,  <reimth@googlemail.com> wrote:
> From: Thomas Reim <reimth@gmail.com>
>
>   ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
>   for a DVI connector that is not implemented/existent on the board.
>
>   Fix by applying extented DDC probing for this connector.
>
>   Requires [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
>
>   BugLink: http://bugs.launchpad.net/bugs/810926
>
> Signed-off-by: Thomas Reim <reimth@gmail.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
> index 2e70be2..82dacc6 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -449,6 +449,15 @@ static bool radeon_connector_needs_extended_probe(struct radeon_device *dev,
>                    (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
>                        return true;
>        }
> +       /* ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
> +        * for a DVI connector that is not implemented */
> +       if ((dev->pdev->device == 0x796e) &&
> +           (dev->pdev->subsystem_vendor == 0x1019) &&
> +           (dev->pdev->subsystem_device == 0x2615)) {
> +               if ((connector_type == DRM_MODE_CONNECTOR_DVID) &&
> +                   (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
> +                       return true;
> +       }
>
>        /* Default: no EDID header probe required for DDC probing */
>        return false;
> --
> 1.7.1
>
>
