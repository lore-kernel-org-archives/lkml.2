Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2CGMLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab2CGMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] edac: add a sysfs node that stores the max possible memory location
Date: Wed,  7 Mar 2012 09:11:16 -0300
Message-Id: <1331122278-28458-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
References: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for edac utilities that want to print the memory layout,
including the empty slots.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 116934c..5b48528 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -744,6 +744,21 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data,
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
+static ssize_t mci_max_location_show(struct mem_ctl_info *mci, char *data,
+				void *priv)
+{
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
 #ifdef CONFIG_EDAC_DEBUG
 static ssize_t edac_fake_inject_show(struct mem_ctl_info *mci,
 				     char *data, void *priv)
@@ -839,6 +854,7 @@ MCIDEV_ATTR(ue_noinfo_count, S_IRUGO, mci_ue_noinfo_show, NULL);
 MCIDEV_ATTR(ce_noinfo_count, S_IRUGO, mci_ce_noinfo_show, NULL);
 MCIDEV_ATTR(ue_count, S_IRUGO, mci_ue_count_show, NULL);
 MCIDEV_ATTR(ce_count, S_IRUGO, mci_ce_count_show, NULL);
+MCIDEV_ATTR(max_location, S_IRUGO, mci_max_location_show, NULL);
 
 /* memory scrubber attribute file */
 MCIDEV_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
@@ -854,6 +870,7 @@ static struct mcidev_sysfs_attribute *mci_attr[] = {
 	&mci_attr_ue_count,
 	&mci_attr_ce_count,
 	&mci_attr_sdram_scrub_rate,
+	&mci_attr_max_location,
 	NULL
 };
 
-- 
1.7.8

