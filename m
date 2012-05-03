Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab2ECOYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:24:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58826 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab2ECOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:24:33 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2 04/16] block: add sysfs attributes for runtime control of dpmg and swapin
Date: Thu, 3 May 2012 19:53:03 +0530
Message-ID: <1336054995-22988-5-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs entries for DPMG and SWAPIN requests so that they can
be set/reset from userspace.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 block/blk-sysfs.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cf15001..764de9f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -213,6 +213,8 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 }
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
+QUEUE_SYSFS_BIT_FNS(expedite_dmpg, EXP_DMPG, 0);
+QUEUE_SYSFS_BIT_FNS(expedite_swapin, EXP_SWAPIN, 0);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
@@ -387,6 +389,18 @@ static struct queue_sysfs_entry queue_random_entry = {
 	.store = queue_store_random,
 };
 
+static struct queue_sysfs_entry queue_dmpg_entry = {
+	.attr = {.name = "expedite_demandpaging", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_expedite_dmpg,
+	.store = queue_store_expedite_dmpg,
+};
+
+static struct queue_sysfs_entry queue_swapin_entry = {
+	.attr = {.name = "expedite_swapping", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_expedite_swapin,
+	.store = queue_store_expedite_swapin,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -409,6 +423,8 @@ static struct attribute *default_attrs[] = {
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
 	&queue_random_entry.attr,
+	&queue_dmpg_entry.attr,
+	&queue_swapin_entry.attr,
 	NULL,
 };
 
-- 
1.7.10.rc2

