Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0LMA2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:28:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44746 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab0LLXp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, ari.m.savolainen@gmail.com, khali@linux-fr.org,
        airlied@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [32/223] drm/radeon/kms: register an i2c adapter name for the dp aux bus
Message-Id: <20101212234528.8E1EAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit a5193fe50e7f21c26d22c17c8196420fac1a3ca7 upstream.

This causes the connector to not be added since i2c init fails
for the adapter.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=31688

Noticed by Ari Savolainen.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Cc: Ari Savolainen <ari.m.savolainen@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_i2c.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/gpu/drm/radeon/radeon_i2c.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/radeon_i2c.c
+++ linux/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -942,6 +942,7 @@ struct radeon_i2c_chan *radeon_i2c_creat
 	i2c->rec = *rec;
 	i2c->adapter.owner = THIS_MODULE;
 	i2c->dev = dev;
+	sprintf(i2c->adapter.name, "Radeon aux bus %s", name);
 	i2c_set_adapdata(&i2c->adapter, i2c);
 	i2c->adapter.algo_data = &i2c->algo.dp;
 	i2c->algo.dp.aux_ch = radeon_dp_i2c_aux_ch;
