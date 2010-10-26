Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab0JZBNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:13:34 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:38679 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab0JZBMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:18 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 25/30] staging/vme_user: add missing calls to vme_master_free calls in .remove
Date: Mon, 25 Oct 2010 21:11:11 -0400
Message-Id: <1288055476-19438-26-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index a1cb85b..75f6472 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -847,8 +847,10 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_sl
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
 	class_destroy(vme_user_sysfs_class);
 
-	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
+	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++) {
 		kfree(image[i].kern_buf);
+		vme_master_free(image[i].resource);
+	}
 
 	for (i = SLAVE_MINOR; i < (SLAVE_MAX + 1); i++) {
 		buf_unalloc(i);
-- 
1.7.1

