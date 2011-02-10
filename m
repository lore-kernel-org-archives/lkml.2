Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1BJRV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:21:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44587 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab1BJRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:27 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/30] EDAC: Shut up sysfs registration debug code
Date: Thu, 10 Feb 2011 18:15:04 +0100
Message-Id: <1297358133-14320-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Raise the debug level of these routines so that their output get issued
out only when the highest debug level is selected. Otherwise, don't
pollute driver debug output.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mc_sysfs.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 39d97cf..73196f7 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -785,10 +785,10 @@ static int edac_create_mci_instance_attributes(struct mem_ctl_info *mci,
 {
 	int err;
 
-	debugf1("%s()\n", __func__);
+	debugf4("%s()\n", __func__);
 
 	while (sysfs_attrib) {
-		debugf1("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
+		debugf4("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
 		if (sysfs_attrib->grp) {
 			struct mcidev_sysfs_group_kobj *grp_kobj;
 
@@ -818,7 +818,7 @@ static int edac_create_mci_instance_attributes(struct mem_ctl_info *mci,
 			if (err < 0)
 				return err;
 		} else if (sysfs_attrib->attr.name) {
-			debugf0("%s() file %s\n", __func__,
+			debugf4("%s() file %s\n", __func__,
 				sysfs_attrib->attr.name);
 
 			err = sysfs_create_file(kobj, &sysfs_attrib->attr);
@@ -853,26 +853,26 @@ static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
 	 * Remove first all the atributes
 	 */
 	while (sysfs_attrib) {
-		debugf1("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
+		debugf4("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
 		if (sysfs_attrib->grp) {
-			debugf1("%s() seeking for group %s\n",
+			debugf4("%s() seeking for group %s\n",
 				__func__, sysfs_attrib->grp->name);
 			list_for_each_entry(grp_kobj,
 					    &mci->grp_kobj_list, list) {
-				debugf1("%s() grp_kobj->grp = %p\n",__func__, grp_kobj->grp);
+				debugf4("%s() grp_kobj->grp = %p\n",__func__, grp_kobj->grp);
 				if (grp_kobj->grp == sysfs_attrib->grp) {
 					edac_remove_mci_instance_attributes(mci,
 						    grp_kobj->grp->mcidev_attr,
 						    &grp_kobj->kobj, count + 1);
-					debugf0("%s() group %s\n", __func__,
+					debugf4("%s() group %s\n", __func__,
 						sysfs_attrib->grp->name);
 					kobject_put(&grp_kobj->kobj);
 				}
 			}
-			debugf1("%s() end of seeking for group %s\n",
+			debugf4("%s() end of seeking for group %s\n",
 				__func__, sysfs_attrib->grp->name);
 		} else if (sysfs_attrib->attr.name) {
-			debugf0("%s() file %s\n", __func__,
+			debugf4("%s() file %s\n", __func__,
 				sysfs_attrib->attr.name);
 			sysfs_remove_file(kobj, &sysfs_attrib->attr);
 		} else
@@ -979,7 +979,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 	debugf0("%s()\n", __func__);
 
 	/* remove all csrow kobjects */
-	debugf0("%s()  unregister this mci kobj\n", __func__);
+	debugf4("%s()  unregister this mci kobj\n", __func__);
 	for (i = 0; i < mci->nr_csrows; i++) {
 		if (mci->csrows[i].nr_pages > 0) {
 			debugf0("%s()  unreg csrow-%d\n", __func__, i);
@@ -989,18 +989,18 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	/* remove this mci instance's attribtes */
 	if (mci->mc_driver_sysfs_attributes) {
-		debugf0("%s()  unregister mci private attributes\n", __func__);
+		debugf4("%s()  unregister mci private attributes\n", __func__);
 		edac_remove_mci_instance_attributes(mci,
 						mci->mc_driver_sysfs_attributes,
 						&mci->edac_mci_kobj, 0);
 	}
 
 	/* remove the symlink */
-	debugf0("%s()  remove_link\n", __func__);
+	debugf4("%s()  remove_link\n", __func__);
 	sysfs_remove_link(&mci->edac_mci_kobj, EDAC_DEVICE_SYMLINK);
 
 	/* unregister this instance's kobject */
-	debugf0("%s()  remove_mci_instance\n", __func__);
+	debugf4("%s()  remove_mci_instance\n", __func__);
 	kobject_put(&mci->edac_mci_kobj);
 }
 
-- 
1.7.4.rc2

