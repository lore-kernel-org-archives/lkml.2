Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0LCOU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:20:57 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:47257 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab0LCOU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:20:56 -0500
Subject: [PATCH] staging/vme_user: add missing calls to vme_master_free calls
	in .remove
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 Dec 2010 14:20:51 +0000
Message-ID: <20101203142051.17155.30135.stgit@ES-BJ21R4J>
In-Reply-To: <1288055476-19438-26-git-send-email-cota@braap.org>
References: <1288055476-19438-26-git-send-email-cota@braap.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index db445ed..a571173 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -852,8 +852,10 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus,
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
 	class_destroy(vme_user_sysfs_class);
 
-	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
+	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++) {
 		kfree(image[i].kern_buf);
+		vme_master_free(image[i].resource);
+	}
 
 	for (i = SLAVE_MINOR; i < (SLAVE_MAX + 1); i++) {
 		vme_slave_set(image[i].resource, 0, 0, 0, 0, VME_A32, 0);


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
