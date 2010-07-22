Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0GVAiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:38:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:59982 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0GVAhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3/5] Fix merge regression from external kdb to upstream kdb
Date: Wed, 21 Jul 2010 19:36:13 -0500
Message-Id: <1279758975-16658-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1279758975-16658-3-git-send-email-jason.wessel@windriver.com>
References: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-2-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Jul 2010 00:36:31.0143 (UTC) FILETIME=[EDE56370:01CB2935]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of merging kdb to the mainline, the kdb lsmod command
stopped printing the base load address of kernel modules.  This is
needed for using kdb in conjunction with external tools such as gdb.

Simply restore the functionality by adding a kdb_printf for the base
load address of the kernel modules.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index a7fe2e9..7e9bfd5 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1883,6 +1883,7 @@ static int kdb_lsmod(int argc, const char **argv)
 			kdb_printf(" (Loading)");
 		else
 			kdb_printf(" (Live)");
+		kdb_printf(" 0x%p", mod->module_core);
 
 #ifdef CONFIG_MODULE_UNLOAD
 		{
-- 
1.6.3.3

