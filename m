Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BUPU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:20:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44193 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1BUPUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:20:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TB5D2tF+fSo8otjbB3s1TQKewbq5v1UzDM8FgonnPx+4Vv4Tgg56Yur6AsZdQK3pS6
         2Q/MyTOvzx3kkicrHsn0GC1kwTL389MSszuJNM2ZB78rI54zLDOjhmwXfQV2BSTtr1VK
         P23XrfhpoA7gGY6IeF4x/CpTUlxyLkIFCvq14=
MIME-Version: 1.0
In-Reply-To: <1298239052.25491.2.camel@t60prh>
References: <AANLkTi=vkmkhcj3dCCGBDvBqdRpJMQi+FwVhGzFTVOp+@mail.gmail.com>
	<1298239052.25491.2.camel@t60prh>
Date: Mon, 21 Feb 2011 16:20:00 +0100
Message-ID: <AANLkTi=nPXd1MnH=NAxQTDZZ1N38UGNsaKqsgf8TryXf@mail.gmail.com>
Subject: Re: v2.6.38-rc5: drm-radeon regression
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <maraeo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/20 Dave Airlie <airlied@redhat.com>:
> On Sun, 2011-02-20 at 11:24 +0100, Jörg Otte wrote:
>> Reaching the desktop in v2.6.38-rc5 I only see the background.
>> No Icon,widgets,windows etc. I am under the impression
>> that everything is there - but invisible.
>
> Does this help?
>
> From 9f159e5f1fd56409718e14913f0fef5fedc09fc8 Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Mon, 21 Feb 2011 07:56:04 +1000
> Subject: [PATCH] drm/radeon: fix regression with AA resolve checking
>
> Some userspaces can emit a whole packet without disabling AA resolve
> by the looks of it, so we have to deal with them.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/gpu/drm/radeon/r100.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/r100.c
> b/drivers/gpu/drm/radeon/r100.c
> index 56deae5..8b0d117 100644
> --- a/drivers/gpu/drm/radeon/r100.c
> +++ b/drivers/gpu/drm/radeon/r100.c
> @@ -3490,7 +3490,7 @@ void r100_cs_track_clear(struct radeon_device
> *rdev, struct r100_cs_track *track
>                track->num_texture = 16;
>                track->maxy = 4096;
>                track->separate_cube = 0;
> -               track->aaresolve = true;
> +               track->aaresolve = false;
>                track->aa.robj = NULL;
>        }
>

Yes, this works.

Thanks!
