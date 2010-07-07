Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0GGVkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53446 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab0GGVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/18] lkdtm: use generic_file_llseek in debugfs
Date: Wed,  7 Jul 2010 23:40:05 +0200
Message-Id: <1278538820-1392-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zDdVEvnx5xsdyMi+z7c7tcRRV7I4RVmCCSJm4PlAzyK
 9FLOcI7pjy19kofrE4OIaqytBI+uyNaWnfnmJ+/aKb08KS7707
 Yo6qJAfMa8dFFx0y9O0IYobcixcsEozve85oPDArbtCrVvTR3/
 MqNnwxcP4kkzFzKd0KEw9mh/YHqhEi3vnlab/P45Y2ypydnIa+
 8VdrgXh5uwgCFU7cBXK7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the default llseek behavior gets changed to
not allowing seek, all file operations that rely
on the current behaviour need to use an explicit
.llseek operation.

The files that lkdtm uses in debugfs are regular
files and they get read using simple_read_from_buffer,
so generic_file_llseek is the right operation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/misc/lkdtm.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 5bfb2a2..7d7ce0e 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -575,30 +575,39 @@ struct crash_entry {
 
 static const struct crash_entry crash_entries[] = {
 	{"DIRECT", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = direct_entry} },
 	{"INT_HARDWARE_ENTRY", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = int_hardware_entry} },
 	{"INT_HW_IRQ_EN", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = int_hw_irq_en} },
 	{"INT_TASKLET_ENTRY", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = int_tasklet_entry} },
 	{"FS_DEVRW", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = fs_devrw_entry} },
 	{"MEM_SWAPOUT", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = mem_swapout_entry} },
 	{"TIMERADD", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = timeradd_entry} },
 	{"SCSI_DISPATCH_CMD", {.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = scsi_dispatch_cmd_entry} },
 	{"IDE_CORE_CP",	{.read = lkdtm_debugfs_read,
+			.llseek = generic_file_llseek,
 			.open = lkdtm_debugfs_open,
 			.write = ide_core_cp_entry} },
 };
-- 
1.7.1

