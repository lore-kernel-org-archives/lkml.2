Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab2ERQpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572Ab2ERQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: [PATCH EDAC v26 48/66] edac: add a sysfs node to report the maximum location for the system
Date: Fri, 18 May 2012 13:32:35 -0300
Message-Id: <1337358773-6919-49-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace tools need to know what's the maximum location on each
system, as it helps to create nice maps showing how the memory was
filled at the system.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Greg K H <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 86da176..87fb396 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -766,6 +766,23 @@ static ssize_t mci_size_mb_show(struct device *dev,
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
+static ssize_t mci_max_location_show(struct device *dev,
+				     struct device_attribute *mattr,
+				     char *data)
+{
+	struct mem_ctl_info *mci = to_mci(dev);
+	int i;
+	char *p = data;
+
+	for (i = 0; i < mci->n_layers; i++) {
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     mci->layers[i].size - 1);
+	}
+
+	return p - data;
+}
+
 /* default Control file */
 DEVICE_ATTR(reset_counters, S_IWUSR, NULL, mci_reset_counters_store);
 
@@ -777,6 +794,7 @@ DEVICE_ATTR(ue_noinfo_count, S_IRUGO, mci_ue_noinfo_show, NULL);
 DEVICE_ATTR(ce_noinfo_count, S_IRUGO, mci_ce_noinfo_show, NULL);
 DEVICE_ATTR(ue_count, S_IRUGO, mci_ue_count_show, NULL);
 DEVICE_ATTR(ce_count, S_IRUGO, mci_ce_count_show, NULL);
+DEVICE_ATTR(max_location, S_IRUGO, mci_max_location_show, NULL);
 
 /* memory scrubber attribute file */
 DEVICE_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
@@ -792,6 +810,7 @@ static struct attribute *mci_attrs[] = {
 	&dev_attr_ue_count.attr,
 	&dev_attr_ce_count.attr,
 	&dev_attr_sdram_scrub_rate.attr,
+	&dev_attr_max_location.attr,
 	NULL
 };
 
-- 
1.7.8

