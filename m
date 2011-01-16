Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1APSui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:50:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36463 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1APSue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VfbCUd4elaZG6JfUFMnv0Qhma1pCXajsTiY6EIKd3UCkUmMXzdl7kEkq8u8Uk7x4w2
         NL3Ndsjc91MGfKgr3FScicOsLcrPpTvUnF71tmhGfFc3BXL6mUjjMbXe/6s5FtPC3fiC
         uSmZlGw5VX+uY8STeMGm2xfS+oCBynJhAON40=
MIME-Version: 1.0
In-Reply-To: <AANLkTimG+61dj-KNeAJZLta4+r1TyXyo1nO7VwJnxUW7@mail.gmail.com>
References: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com>
	<AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com>
	<AANLkTinVDdUX70E12fqJBBsd+zKDF4zpnG4YSUhCuQCD@mail.gmail.com>
	<AANLkTimG+61dj-KNeAJZLta4+r1TyXyo1nO7VwJnxUW7@mail.gmail.com>
Date: Sun, 16 Jan 2011 20:50:29 +0200
Message-ID: <AANLkTikfp56XBE+B0hvvYD2nSJXpQ65XO7gwL2ZLU5uU@mail.gmail.com>
Subject: Re: Please revert nouveau.
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partial bisected:
https://lkml.org/lkml/2011/1/11/276

and:
https://lkml.org/lkml/2011/1/13/271


after
git revert dfe63bb0ad9810db13aab0058caba97866e0a681

and

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 5c4f9b9..2aad663 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -816,6 +816,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
                        mutex_unlock(&dev->mode_config.mutex);
                        return ret;
                }
+               drm_fb_helper_fill_fix(info, fb_helper->fb->pitch,
fb_helper->fb->depth);
        }
        mutex_unlock(&dev->mode_config.mutex);

I have an partial working sistem.
