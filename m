Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1DJHPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 03:15:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33018 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1DJHP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 03:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u4TWuetj9yBnOPwnInzDDk8GQQeV2zZwG5hz96+IFgE4z02qJ6Sv3m1XAKsh1MyiOv
         /Fa/8iR3P1it5ljtNPwuDcx1Fv9YMlvJrsPv2dgkAFHqPxdWHsUJ/3XCoHW89ohmsGrr
         TqZVmEwasK30cD43m5/TL3H0pgqe/+Z8MtQoE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104100232210.22602@localhost6.localdomain6>
References: <alpine.DEB.2.00.1104100232210.22602@localhost6.localdomain6>
Date: Sun, 10 Apr 2011 10:15:25 +0300
X-Google-Sender-Auth: twyCFIWnQ5nQ2hg4dpt2amp5JXU
Message-ID: <BANLkTi=ck-zM8GMPeFq_vrZWkWnXo4ZP+Q@mail.gmail.com>
Subject: Re: it *appears* the i915 black screen of death issue is back
From: Pekka Enberg <penberg@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: dri-devel@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Fixing your CC list. ]

On Sun, Apr 10, 2011 at 9:35 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>  when i built a new kernel based on the latest git tree, i once again
> got the black screen of death on my gateway laptop with an integrated
> intel graphics controller.
>
>  and as i did not that long ago, i got around it by applying the
> following tweak to the source tree before rebuilding:
>
> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> index d2c7104..a1a5d03 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -152,6 +152,8 @@ static u32 asle_set_backlight(struct drm_device
> *dev, u32 bclp)
>        struct opregion_asle *asle = dev_priv->opregion.asle;
>        u32 max;
>
> +return ASLE_BACKLIGHT_FAILED; // rday
> +
>        if (!(bclp & ASLE_BCLP_VALID))
>                return ASLE_BACKLIGHT_FAILED;
>
>
>  so if this issue was resolved, it seems to have regressed.
>
> rday
>
> --
>
> ========================================================================
> Robert P. J. Day                                 Ottawa, Ontario, CANADA
>                        http://crashcourse.ca
>
> Twitter:                                       http://twitter.com/rpjday
> LinkedIn:                               http://ca.linkedin.com/in/rpjday
> ========================================================================
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
