Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1KDKQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:16:51 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:45915 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1KDKQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:16:49 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 2/3] staging: vme: remove vme_add_bus() and vme_remove_bus()
Date: Fri, 4 Nov 2011 11:12:30 +0100
Message-ID: <1320401551-29287-3-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch>
References: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions vme_add_bus() and vme_remove_bus() were only being used
in the vme_register_bridge() and vme_unregister_bridge() functions
respectively. This patch gets rid of them and moves their code to
vme_register_bridge() and vme_unregister_bridge().

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 3cbc69c..4c6dc69 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1307,7 +1307,12 @@ EXPORT_SYMBOL(vme_slot_get);
 
 /* - Bridge Registration --------------------------------------------------- */
 
-static int vme_add_bus(struct vme_bridge *bridge)
+static void vme_dev_release(struct device *dev)
+{
+	kfree(dev_to_vme_dev(dev));
+}
+
+int vme_register_bridge(struct vme_bridge *bridge)
 {
 	int i;
 	int ret = -1;
@@ -1327,8 +1332,9 @@ static int vme_add_bus(struct vme_bridge *bridge)
 
 	return ret;
 }
+EXPORT_SYMBOL(vme_register_bridge);
 
-static void vme_remove_bus(struct vme_bridge *bridge)
+void vme_unregister_bridge(struct vme_bridge *bridge)
 {
 	struct vme_dev *vdev;
 	struct vme_dev *tmp;
@@ -1343,22 +1349,6 @@ static void vme_remove_bus(struct vme_bridge *bridge)
 	list_del(&bridge->bus_list);
 	mutex_unlock(&vme_buses_lock);
 }
-
-static void vme_dev_release(struct device *dev)
-{
-	kfree(dev_to_vme_dev(dev));
-}
-
-int vme_register_bridge(struct vme_bridge *bridge)
-{
-	return vme_add_bus(bridge);
-}
-EXPORT_SYMBOL(vme_register_bridge);
-
-void vme_unregister_bridge(struct vme_bridge *bridge)
-{
-	vme_remove_bus(bridge);
-}
 EXPORT_SYMBOL(vme_unregister_bridge);
 
 /* - Driver Registration --------------------------------------------------- */
-- 
1.7.4.1

