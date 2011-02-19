Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1BSMLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 07:11:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35861 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1BSMLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 07:11:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PQeQ5uQCwZdDlgCCppV7qb6huub/7gedurLYUjJPj9zTkceUKlih8x/1k+5o+332FQ
         E7F7USyVxSIAIwBKjmdR+ElBjs/kao0uRlgmyUOfDYCWm12puDJ+nxK7eQ36Imsebvrm
         1nCPxsbzjMR3Xa2JqhqdmhaR6eANB+jXRl/iM=
MIME-Version: 1.0
In-Reply-To: <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<20110217221329.GA3332@x61.home>
	<3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
Date: Sat, 19 Feb 2011 13:11:00 +0100
Message-ID: <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
From: Alex Riesen <raa.lkml@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for this late answer. I only get a very little time for this.

On Fri, Feb 18, 2011 at 05:57, Indan Zupancic <indan@nul.nu> wrote:
> On Thu, February 17, 2011 23:13, Tino Keitel wrote:
>> with kernel 2.6.37, the display brightness of my ThinkPad X61s was
>> always reduced after lid open, resume from suspend etc.  With this
>> patch on top of 2.6.38-rc5, the problem is gone.  Thanks.
>
> Tino, I think Alex's patch only hides the problem and doesn't properly solve

Could well be. I don't understand what the code is supposed to do.
The patch was created just be looking at diffs.

> the real bug. Can you confirm that this is the bit that fixes it for you?
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index c65992d..c4b1ca4 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -267,6 +235,9 @@ void intel_panel_enable_backlight(struct drm_device *dev)
>  {
>        struct drm_i915_private *dev_priv = dev->dev_private;
>
> +       if (dev_priv->backlight_enabled)
> +               return;
> +
>        if (dev_priv->backlight_level == 0)
>                dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
>
> (Alex's patch edited by hand, offsets might be wrong.)

It is not enough, at least for me.

> The other bits either don't change the logic, or should be harmless, or are
> plain wrong, like setting the brightness to maximum at bootup.

I am not absolutely sure, but I don't think this is what happens on this laptop.

> Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447 fixes
> it for you too? (Make sure you're at max brightness before rebooting.)

I'll try it now.
