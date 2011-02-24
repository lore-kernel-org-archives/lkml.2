Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab1BXTZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:25:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64530 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab1BXTZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UPzTWyQ8TJAo7ZHYKwvr/m+/YrKLVcDohxTZDfgHIS645FX5AgOj8VsBboo+WfTTXv
         /aJoR1hbVG4ytK3rXZHWpzQBtXX8QIHvqpJ2ww6Khv73uel3R35cRxiJQO1nZDWU5xrG
         qSIHO6et0G7rect7QtLe+e04T1xvVM9Zrb4gY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
	<AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
	<0d30dc$l7ehaa@orsmga001.jf.intel.com>
	<AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
	<b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
	<AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
Date: Thu, 24 Feb 2011 20:25:18 +0100
Message-ID: <AANLkTinD5HJGwxKUKqCtpLY1cNC9JJX8vqECYC8nhpUe@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Riesen <raa.lkml@gmail.com>
To: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Indan Zupancic <indan@nul.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 20:04, Alex Riesen <raa.lkml@gmail.com> wrote:
> So, AFAICS, at the moment there is no better patch than this:
>
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 17bd766..8f8a6a3 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -764,7 +764,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
>                break;
>        case I915_PARAM_HAS_RELAXED_FENCING:
>                value = 1;
> -               break;
> +               return -EINVAL;
>        case I915_PARAM_HAS_COHERENT_RINGS:
>                value = 1;
>                break;
>

Probably unrelated, but I managed to get a cursor corruption with
just this patch. So maybe, I still need that fix from Daniel: an X
cursor seem to meet that pixmap size requirements. And corruption
picture fits too: stripes and dots in lower left corner of where
a part of the cursor image should have been.

Can't reproduce, though.
