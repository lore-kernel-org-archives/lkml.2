Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2AJW52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:57:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab2AJW50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:57:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:18 2012
Message-Id: <20120110214618.834071260@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pontus Fuchs <pontus.fuchs@gmail.com>,
        Luciano Coelho <coelho@ti.com>
Subject: [07/40] wl12xx: Validate FEM index from ini file and FW
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pontus Fuchs <pontus.fuchs@gmail.com>

commit 2131d3c2f99b081806fdae7662c92fe6acda52af upstream.

Check for out of bound FEM index to prevent reading beyond ini
memory end.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/cmd.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -121,6 +121,11 @@ int wl1271_cmd_general_parms(struct wl12
 	if (!wl->nvs)
 		return -ENODEV;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from INI out of bounds");
+		return -EINVAL;
+	}
+
 	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
 	if (!gen_parms)
 		return -ENOMEM;
@@ -144,6 +149,12 @@ int wl1271_cmd_general_parms(struct wl12
 	gp->tx_bip_fem_manufacturer =
 		gen_parms->general_params.tx_bip_fem_manufacturer;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from FW out of bounds");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
 		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
 
@@ -163,6 +174,11 @@ int wl128x_cmd_general_parms(struct wl12
 	if (!wl->nvs)
 		return -ENODEV;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from ini out of bounds");
+		return -EINVAL;
+	}
+
 	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
 	if (!gen_parms)
 		return -ENOMEM;
@@ -187,6 +203,12 @@ int wl128x_cmd_general_parms(struct wl12
 	gp->tx_bip_fem_manufacturer =
 		gen_parms->general_params.tx_bip_fem_manufacturer;
 
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from FW out of bounds");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
 		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
 


