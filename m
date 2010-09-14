Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0INU0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:26:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0INUXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/15] lkdtm: use generic_file_llseek in debugfs
Date: Tue, 14 Sep 2010 22:22:31 +0200
Message-Id: <1284495763-7506-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:q/MOPMM20Gsg9J66Bswz5N1zkD7LVi8IV7ot2wcZNis
 gaR7nOM55z1LyEK+H83PD4ThJ8y9lYQ+n6Pu5PlsI0wHZC0aco
 4ovUeCWOVkjSJ5CR7rJFeOHhZwKzl5d7/n90rqJ9/rn5XHjcqI
 DRLIQVV512Juyg0yrf///9NrPfxyaWj5nNlhSzJMZwzRQjVYkt
 1JlL7HMUDkWDkToqFGF0g==
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
index ef34de7..343b5d8 100644
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

