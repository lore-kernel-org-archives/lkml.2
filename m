Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2JPN13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab2JPN12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:27:28 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Mauro Chehab <mchehab@redhat.com>,
        linux-edac@vger.kernel.org
Subject: [PATCH RESEND] i7core_edac, Fix panic when accessing sysfs files
Date: Tue, 16 Oct 2012 09:27:20 -0400
Message-Id: <1350394040-11277-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i7core_edac addrmatch_dev and chancounts_dev have sysfs files
associated with them.  The sysfs files, however, are coded so that the
parent device is is the mci device.  This is incorrect and the mci struct
should be obtained through the addrmatch_dev and chancounts_dev device's
private data field which is populated in i7core_create_sysfs_devices().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Mauro Chehab <mchehab@redhat.com>
Cc: linux-edac@vger.kernel.org
---
 drivers/edac/i7core_edac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 3672101..10c8c00 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -816,7 +816,7 @@ static ssize_t i7core_inject_store_##param(			\
 	struct device_attribute *mattr,				\
 	const char *data, size_t count)				\
 {								\
-	struct mem_ctl_info *mci = to_mci(dev);			\
+	struct mem_ctl_info *mci = dev_get_drvdata(dev);	\
 	struct i7core_pvt *pvt;					\
 	long value;						\
 	int rc;							\
@@ -845,7 +845,7 @@ static ssize_t i7core_inject_show_##param(			\
 	struct device_attribute *mattr,				\
 	char *data)						\
 {								\
-	struct mem_ctl_info *mci = to_mci(dev);			\
+	struct mem_ctl_info *mci = dev_get_drvdata(dev);	\
 	struct i7core_pvt *pvt;					\
 								\
 	pvt = mci->pvt_info;					\
@@ -1052,7 +1052,7 @@ static ssize_t i7core_show_counter_##param(			\
 	struct device_attribute *mattr,				\
 	char *data)						\
 {								\
-	struct mem_ctl_info *mci = to_mci(dev);			\
+	struct mem_ctl_info *mci = dev_get_drvdata(dev);	\
 	struct i7core_pvt *pvt = mci->pvt_info;			\
 								\
 	edac_dbg(1, "\n");					\
-- 
1.7.12.1

