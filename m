Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423900Ab2LGBDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:03:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423608Ab2LGBAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Prarit Bhargava <prarit@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 19/27] i7core_edac: fix panic when accessing sysfs files
Date: Thu,  6 Dec 2012 16:59:03 -0800
Message-Id: <20121207005831.466804325@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit 42709efb3a47524c6252e1bdc85e205f7bc356fb upstream.

The i7core_edac addrmatch_dev and chancounts_dev have sysfs files
associated with them.  The sysfs files, however, are coded so that the
parent device is is the mci device.  This is incorrect and the mci struct
should be obtained through the addrmatch_dev and chancounts_dev device's
private data field which is populated in i7core_create_sysfs_devices().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i7core_edac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -816,7 +816,7 @@ static ssize_t i7core_inject_store_##par
 	struct device_attribute *mattr,				\
 	const char *data, size_t count)				\
 {								\
-	struct mem_ctl_info *mci = to_mci(dev);			\
+	struct mem_ctl_info *mci = dev_get_drvdata(dev);	\
 	struct i7core_pvt *pvt;					\
 	long value;						\
 	int rc;							\
@@ -845,7 +845,7 @@ static ssize_t i7core_inject_show_##para
 	struct device_attribute *mattr,				\
 	char *data)						\
 {								\
-	struct mem_ctl_info *mci = to_mci(dev);			\
+	struct mem_ctl_info *mci = dev_get_drvdata(dev);	\
 	struct i7core_pvt *pvt;					\
 								\
 	pvt = mci->pvt_info;					\
@@ -1052,7 +1052,7 @@ static ssize_t i7core_show_counter_##par
 	struct device_attribute *mattr,				\
 	char *data)						\
 {								\
-	struct mem_ctl_info *mci = to_mci(dev);			\
+	struct mem_ctl_info *mci = dev_get_drvdata(dev);	\
 	struct i7core_pvt *pvt = mci->pvt_info;			\
 								\
 	edac_dbg(1, "\n");					\


