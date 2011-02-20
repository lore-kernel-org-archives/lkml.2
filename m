Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1BTWEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 17:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1BTWEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 17:04:10 -0500
Subject: Re: v2.6.38-rc5: drm-radeon regression
From: Dave Airlie <airlied@redhat.com>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
        Marek =?UTF-8?Q?Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>
In-Reply-To: <AANLkTi=vkmkhcj3dCCGBDvBqdRpJMQi+FwVhGzFTVOp+@mail.gmail.com>
References: <AANLkTi=vkmkhcj3dCCGBDvBqdRpJMQi+FwVhGzFTVOp+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 07:57:32 +1000
Message-ID: <1298239052.25491.2.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 11:24 +0100, Jörg Otte wrote:
> Reaching the desktop in v2.6.38-rc5 I only see the background.
> No Icon,widgets,windows etc. I am under the impression
> that everything is there - but invisible.

Does this help?

>From 9f159e5f1fd56409718e14913f0fef5fedc09fc8 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Mon, 21 Feb 2011 07:56:04 +1000
Subject: [PATCH] drm/radeon: fix regression with AA resolve checking

Some userspaces can emit a whole packet without disabling AA resolve
by the looks of it, so we have to deal with them.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c
b/drivers/gpu/drm/radeon/r100.c
index 56deae5..8b0d117 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3490,7 +3490,7 @@ void r100_cs_track_clear(struct radeon_device
*rdev, struct r100_cs_track *track
 		track->num_texture = 16;
 		track->maxy = 4096;
 		track->separate_cube = 0;
-		track->aaresolve = true;
+		track->aaresolve = false;
 		track->aa.robj = NULL;
 	}
 
-- 
1.7.3.4



