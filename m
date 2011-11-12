Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1KLRCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 12:02:49 -0500
Received: from www17.your-server.de ([213.133.104.17]:42152 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1KLRCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 12:02:47 -0500
Message-ID: <1321117365.1624.8.camel@localhost.localdomain>
Subject: [PATCH] gma500: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 12 Nov 2011 18:02:45 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/gma500/intel_bios.c b/drivers/staging/gma500/intel_bios.c
--- a/drivers/staging/gma500/intel_bios.c 2011-11-07 19:38:10.703630794 +0100
+++ b/drivers/staging/gma500/intel_bios.c 2011-11-08 10:52:10.090491565 +0100
@@ -104,12 +104,11 @@ static void parse_backlight_data(struct
 	bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
 	vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
 
-	lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
+	lvds_bl = kmemdup(vbt_lvds_bl, sizeof(*vbt_lvds_bl), GFP_KERNEL);
 	if (!lvds_bl) {
 		dev_err(dev_priv->dev->dev, "out of memory for backlight data\n");
 		return;
 	}
-	memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
 	dev_priv->lvds_bl = lvds_bl;
 }
 



