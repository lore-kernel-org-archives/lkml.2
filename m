Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1E0XWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:22:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab1E0XWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:22:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [PATCH] Subject: shmobile: Fix build of the LCDC driver
Date: Sat, 28 May 2011 01:23:06 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105280123.06622.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The shmobile lcdcfb driver fails to build because of the undefined
ret variable in sh_mobile_lcdc_start().  Fix this problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

I don't know whether this is known or not.  In case it isn't,
here's a fix. :-)

Thanks,
Rafael

---
 drivers/video/sh_mobile_lcdcfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/video/sh_mobile_lcdcfb.c
===================================================================
--- linux-2.6.orig/drivers/video/sh_mobile_lcdcfb.c
+++ linux-2.6/drivers/video/sh_mobile_lcdcfb.c
@@ -616,7 +616,7 @@ static int sh_mobile_lcdc_start(struct s
 			struct sh_mobile_meram_info *mdev;
 			unsigned long icb_addr_y, icb_addr_c;
 			int icb_pitch;
-			int pf;
+			int pf, ret;
 
 			cfg = ch->cfg.meram_cfg;
 			mdev = priv->meram_dev;
