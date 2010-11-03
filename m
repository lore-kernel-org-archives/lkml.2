Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0KDAA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 20:00:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59924 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0KDAAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 20:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xzCFWkBGhfQUWBl3dEVXW4TF/C3zHo6pbQtF2p4Do5iu6a2XagHkCQ+2NROzcTyQD6
         SyS7tssOpc8gcLzZNeX5mzqA5hy9IB9q+rPJJ9r8BFiqn0m3/IgC21FvtZaax21h6Yz/
         EYZuXVUPvs15oRM3i5rYHMe1TqW0ATudllObo=
Subject: Re: [Nouveau] [PATCH] nouveau: Don't expose backlight control in
 presence of ACPI
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Aaron Sowry <aaron@aeneby.se>
Cc: airlied@linux.ie, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101103101229.GA4523@aeneby.se>
References: <20101103101229.GA4523@aeneby.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 09:59:53 +1000
Message-ID: <1288828793.22971.0.camel@nisroch>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 11:12 +0100, Aaron Sowry wrote:
> From: Aaron Sowry <aaron@aeneby.se>
> 
> Avoid confusing userspace by not publishing backlight controls if ACPI equivalents are available.
> Signed-off-by: Aaron Sowry <aaron@aeneby.se>
Thanks,

I've pushed an equivalent change into nouveau git.

Ben.
> ---
> --- linux-2.6/drivers/gpu/drm/nouveau/nouveau_state.c.orig      2010-11-03 09:56:29.502828966 +0100
> +++ linux-2.6/drivers/gpu/drm/nouveau/nouveau_state.c   2010-11-03 10:46:27.765829000 +0100
> @@ -23,6 +23,7 @@
>   * DEALINGS IN THE SOFTWARE.
>   */
> 
> +#include <linux/acpi.h>
>  #include <linux/swab.h>
>  #include <linux/slab.h>
>  #include "drmP.h"
> @@ -648,9 +649,14 @@ nouveau_card_init(struct drm_device *dev
>                         goto out_fence;
>         }
> 
> -       ret = nouveau_backlight_init(dev);
> -       if (ret)
> -               NV_ERROR(dev, "Error %d registering backlight\n", ret);
> +       if (acpi_video_backlight_support())
> +               NV_INFO(dev, "Detected ACPI backlight support, "
> +                               "not registering interface\n");
> +       else {
> +               ret = nouveau_backlight_init(dev);
> +               if (ret)
> +                       NV_ERROR(dev, "Error %d registering backlight\n", ret);
> +       }
> 
>         nouveau_fbcon_init(dev);
>         drm_kms_helper_poll_init(dev);
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau


