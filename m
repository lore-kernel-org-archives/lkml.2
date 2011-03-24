Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1CXOSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:18:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42584 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1CXOSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Aa3aQIdhdqKVQN5Wp9tRJsWaEM1K46gyXF5tLBUuOMp/Yu/3okvtVGpv3fetEzSB4l
         5FKufKMXv0b5+moWctlPy2zra7DRTB7PPcaOwUoNBr3+LBHtTbRrThFA3FmBWM0NilQY
         rSFBUxaw/0VlAcN+1QPO+UuPKcj+Eeh1Y/+kQ=
MIME-Version: 1.0
In-Reply-To: <1300973444-6084-1-git-send-email-chris@chris-wilson.co.uk>
References: <AANLkTikY23FxMVtqTNra05O3CxXZQ5=bvmppTiySHNq=@mail.gmail.com>
	<1300973444-6084-1-git-send-email-chris@chris-wilson.co.uk>
Date: Thu, 24 Mar 2011 15:18:33 +0100
Message-ID: <AANLkTik4mvu130VOpdHj7noFQ3SLkGCSAVAQ+OK2=U4S@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/lvds: Always return connected in the absence of
 better information
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 2:30 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> The LVDS connector should default to connected. We tried our best to
> verify the claims of the BIOS that the hardware exists during init(),
> and then during detect() we then try to verify that the panel is open.
> In the event of an unsucessful query, we should then always report
> that the LVDS panel is connected. This was only the case for gen3/4,
> later generations leaked the return value from the panel probe instead.
>
> Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

With this patch on top of 2.6.38-git14, I am back to 1440x900 by default.
Great work, thanks Chris ! FWIW, You can add my

Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>

> ---
>  drivers/gpu/drm/i915/intel_lvds.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> index 1a311ad..86cd30b 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -473,19 +473,13 @@ static enum drm_connector_status
>  intel_lvds_detect(struct drm_connector *connector, bool force)
>  {
>        struct drm_device *dev = connector->dev;
> -       enum drm_connector_status status = connector_status_connected;
> +       enum drm_connector_status status;
>
>        status = intel_panel_detect(dev);
>        if (status != connector_status_unknown)
>                return status;
>
> -       /* ACPI lid methods were generally unreliable in this generation, so
> -        * don't even bother.
> -        */
> -       if (IS_GEN2(dev) || IS_GEN3(dev))
> -               return connector_status_connected;
> -
> -       return status;
> +       return connector_status_connected;
>  }
>
>  /**
> --
> 1.7.4.1
>
>

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
