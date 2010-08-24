Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0HXIya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:54:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0HXIy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VPJRosgJQMZjHga6UPuUghOBQcPh0JW168R/NcquGYlm0M6XmF84l4RmqmsQ4WNErO
         LasFcaD5zoFWZZqGKBDvje/GIa90pvcAeb4ZccOlSwoHKCr3Vk7/tPdzzQITYi+xI4Iy
         UkDB1eq+wcmxHY2d+OY6evowdF30ix427gBJ4=
MIME-Version: 1.0
In-Reply-To: <1282611655.2177.19.camel@localhost.localdomain>
References: <1282611655.2177.19.camel@localhost.localdomain>
Date: Tue, 24 Aug 2010 11:54:26 +0300
X-Google-Sender-Auth: FbIwNInpTp-uGhXbjId7O4PvAls
Message-ID: <AANLkTikYjRQEvRD=6nYVO25yiUPPvEgMwejbMJzhVebm@mail.gmail.com>
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
From: Pekka Enberg <penberg@kernel.org>
To: Ivan Bulatovic <combuster@gmx.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, eric@anholt.net, chris@chris-wilson.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 4:00 AM, Ivan Bulatovic <combuster@gmx.com> wrote:
> While in init3, resolution is native, KMS works fine, no problems at
> all. As soon as gdm starts it seems that TV1 output is recognized as
> connected even if it isn't so resolution on VGA output is degraded from
> native 1280x1024 to 1024x768 on startup.
>
> I've disabled LVDS output with video=LVDS-1:d because the cable looses
> connection in certain lid positions.
>
> 2.6.36-rc1 didn't have this issue, 2.6.36-rc2 did so I've bisected and
> it came down to this commit:
>
> 9d0498a2bf7455159b317f19531a3e5db2ecc9c4 is the first bad commit
> commit 9d0498a2bf7455159b317f19531a3e5db2ecc9c4
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Wed Aug 18 13:20:54 2010 -0700
>
>    drm/i915: wait for actual vblank, not just 20ms
>
> Waiting for a hard coded 20ms isn't always enough to make sure a vblank
> period has actually occurred, so add code to make sure we really have
> passed through a vblank period (or that the pipe is off when disabling).
>
> This prevents problems with mode setting and link training, and seems to
> fix a bug like https://bugs.freedesktop.org/show_bug.cgi?id=29278, but
> on an HP 8440p instead.  Hopefully also fixes
> https://bugs.freedesktop.org/show_bug.cgi?id=29141.
>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> :040000 040000 9941813d0f0bc4e141a87696d34f1d1b9087711b
> 2e407ad1d03b60f0e5b020313a8a63bd176b4005 M drivers
>
> I'm sending you dmesg, xorg and xrandr logs as attachements. GM965 on
> DELL Vostro 1310 is in question. Thanks,

On Tue, Aug 24, 2010 at 4:00 AM, Ivan Bulatovic <combuster@gmx.com> wrote:
> While in init3, resolution is native, KMS works fine, no problems at
> all. As soon as gdm starts it seems that TV1 output is recognized as
> connected even if it isn't so resolution on VGA output is degraded from
> native 1280x1024 to 1024x768 on startup.
>
> I've disabled LVDS output with video=LVDS-1:d because the cable looses
> connection in certain lid positions.
>
> 2.6.36-rc1 didn't have this issue, 2.6.36-rc2 did so I've bisected and
> it came down to this commit:
>
> 9d0498a2bf7455159b317f19531a3e5db2ecc9c4 is the first bad commit
> commit 9d0498a2bf7455159b317f19531a3e5db2ecc9c4
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Wed Aug 18 13:20:54 2010 -0700
>
>    drm/i915: wait for actual vblank, not just 20ms
>
> Waiting for a hard coded 20ms isn't always enough to make sure a vblank
> period has actually occurred, so add code to make sure we really have
> passed through a vblank period (or that the pipe is off when disabling).
>
> This prevents problems with mode setting and link training, and seems to
> fix a bug like https://bugs.freedesktop.org/show_bug.cgi?id=29278, but
> on an HP 8440p instead.  Hopefully also fixes
> https://bugs.freedesktop.org/show_bug.cgi?id=29141.
>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> :040000 040000 9941813d0f0bc4e141a87696d34f1d1b9087711b
> 2e407ad1d03b60f0e5b020313a8a63bd176b4005 M drivers
>
> I'm sending you dmesg, xorg and xrandr logs as attachements. GM965 on
> DELL Vostro 1310 is in question. Thanks,

FWIW, I saw this on my MacBook as well. I was debugging a boot time
oops at the time so I just changed screen resolution in Gnome to fix
it.
