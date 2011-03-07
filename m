Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1CGDO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:14:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56080 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1CGDOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=C5il+mRcZShkGWCSxo6CQleeLIq0CdqRjWolKpzU9GQn82DoyeaN4/L9NAcioR9XyZ
         C0vpeqXEKkdiBIcgIoMBmSkeGQ0unNjiLIuinmD5zKTeeRe9uZFCIHBxDlDYojUspzct
         26B+mvx1lrvQJVbj1EFdIxQETDIIARYQMrAHQ=
Subject: [PATCH] [SCSI] target: Add __init/__exit annotation for
	target_core_init_configfs/target_core_exit_configfs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain
Date: Mon, 07 Mar 2011 11:19:10 +0800
Message-Id: <1299467950.4791.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below section mismatch warning.
WARNING: vmlinux.o(.text+0x21617a): Section mismatch in reference from the function target_core_init_configfs() to the function .init.text:rd_module_init()
The function target_core_init_configfs() references
the function __init rd_module_init().
This is often because target_core_init_configfs lacks a __init
annotation or the annotation of rd_module_init is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/target/target_core_configfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index caf8dc1..378835e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3044,7 +3044,7 @@ static struct config_item_type target_core_cit = {
 
 /* Stop functions for struct config_item_type target_core_hba_cit */
 
-static int target_core_init_configfs(void)
+static int __init target_core_init_configfs(void)
 {
 	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
 	struct config_group *lu_gp_cg = NULL;
@@ -3176,7 +3176,7 @@ out_global:
 	return -1;
 }
 
-static void target_core_exit_configfs(void)
+static void __exit target_core_exit_configfs(void)
 {
 	struct configfs_subsystem *subsys;
 	struct config_group *hba_cg, *alua_cg, *lu_gp_cg;
-- 
1.7.2



