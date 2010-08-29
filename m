Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0H2NAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:00:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0H2NAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=XU/mY8AB0MLt6NnDRJYo4YqtLX2IBrCLNb65p27CZu1LKIt4qHB6HpKTKwiK4QUwlf
         Vi+qB+qPbGw35vd/Yc+IaonDthDYMqtfhDKlqDdQB3sTr86Kt3DG/OsTsch2GGmQFEaS
         WFZzJuqUv+gC/KynCp0RT34baTdvg274xC9lA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Ivan Bulatovic <combuster@gmx.com>
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
Date: Sun, 29 Aug 2010 14:59:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, eric@anholt.net
References: <1282611655.2177.19.camel@localhost.localdomain>
In-Reply-To: <1282611655.2177.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008291459.58165.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 24 sierpnia 2010 o 03:00:55 Ivan Bulatovic wrote:
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
> Date:   Wed Aug 18 13:20:54 2010 -0700
> 
>     drm/i915: wait for actual vblank, not just 20ms
> 
> Waiting for a hard coded 20ms isn't always enough to make sure a vblank
> period has actually occurred, so add code to make sure we really have
> passed through a vblank period (or that the pipe is off when disabling).
> 
> This prevents problems with mode setting and link training, and seems to
> fix a bug like https://bugs.freedesktop.org/show_bug.cgi?id=29278, but
> on an HP 8440p instead.  Hopefully also fixes
> https://bugs.freedesktop.org/show_bug.cgi?id=29141.
> 
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Eric Anholt <eric@anholt.net>
> 
> :040000 040000 9941813d0f0bc4e141a87696d34f1d1b9087711b
> 
> 2e407ad1d03b60f0e5b020313a8a63bd176b4005 M drivers
> 
> I'm sending you dmesg, xorg and xrandr logs as attachements. GM965 on
> DELL Vostro 1310 is in question. Thanks,
> 
> Ivan

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=17301
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
