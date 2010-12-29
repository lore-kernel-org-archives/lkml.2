Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0L2VLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:11:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0L2VLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:11:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fQ0kNNJLikiq6KqawH46jmz/Aoy6zXVyXA/LYxAR4cghJi8T0JLvSM8ur/R975GfWE
         jO3kRTr4PpH7pHbWThS8MzKKVFfeJQHCy0ISNeNqISzSHDsalCDmLVAdzS4YYZ2IzVbD
         GJfnDNfWmUeKThrV33h2bkBIRemOcg4L3c68k=
MIME-Version: 1.0
In-Reply-To: <20101229121601.179983b7@jbarnes-desktop>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
Date: Wed, 29 Dec 2010 22:11:09 +0100
Message-ID: <AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 21:16, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 29 Dec 2010 11:40:04 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> Chris - why did that lvds_ssc_freq thing suddenly start mattering? Can
>> we please just disable spread-spectrum entirely? Or perhaps only if we
>> notice that it was enabled already? Or something?
>
> Randy, Jeff and Alex, does the below help at all?  If so, it may be the
> minimal fix we want for 2.6.37.

Something broke your patch: whitespace instead of tabs.

> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios
> index 2b20786..d27d016 100644
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -263,6 +263,9 @@ parse_general_features(struct drm_i915_private *dev_priv,
>                dev_priv->int_tv_support = general->int_tv_support;
>                dev_priv->int_crt_support = general->int_crt_support;
>                dev_priv->lvds_use_ssc = general->enable_ssc;
> +               /* force disable until we can parse this correctly */

This comment seems to imply that SSC wasn't used at all until recently, right?

> +               if (IS_GEN5(dev) || IS_GEN6(dev))
> +                       dev_priv->lvds_use_ssc = 0;

Doesn't change anything here. Display stays blank.
