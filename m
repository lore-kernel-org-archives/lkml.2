Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2BVScx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:32:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60944 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755211Ab2BVScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:32:51 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19GpLcvWbhGUE23ZchMYP7ay3rfV6Blqp9yzOKA8D
	70K0u+Zzv1ppiQ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/5] viafb: another workaround for OLPCs weird wiring
Date: Wed, 22 Feb 2012 18:53:05 +0000
Message-Id: <78145b7a343fe2950478e649e905f557054df884.1329936280.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329936280.git.FlorianSchandinat@gmx.de>
References: <cover.1329936280.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OLPC we must not touch this I2C bus or it will hang.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 4791165..9cfa92e 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1752,8 +1752,10 @@ static void __devinit i2c_bus_probe(struct viafb_shared *shared)
 	shared->i2c_31 = via_aux_probe(viafb_find_i2c_adapter(VIA_PORT_31));
 
 	/* FIXME: what is this? */
-	printk(KERN_INFO "viafb: Probing I2C bus 0x2C\n");
-	shared->i2c_2C = via_aux_probe(viafb_find_i2c_adapter(VIA_PORT_2C));
+	if (!machine_is_olpc()) {
+		printk(KERN_INFO "viafb: Probing I2C bus 0x2C\n");
+		shared->i2c_2C = via_aux_probe(viafb_find_i2c_adapter(VIA_PORT_2C));
+	}
 
 	printk(KERN_INFO "viafb: Finished I2C bus probing");
 }
-- 
1.7.9

