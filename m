Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2KEQLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:11:46 -0500
Received: from goliath.siemens.de ([192.35.17.28]:19180 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2KEQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:09:25 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 09/13] scripts/gdb: Add is_target_arch helper
Date: Mon,  5 Nov 2012 17:09:02 +0100
Message-Id: <ffbc702c9b10e271af1ba1b4cde5993c526e0713.1352131731.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper caches to result of "show architecture" and matches the
provided arch (sub-)string against that output.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 18e3bfc..31aaf53 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -88,3 +88,12 @@ def read_u64(buffer):
 		return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
 	else:
 		return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
+
+
+target_arch = None
+
+def is_target_arch(arch):
+	global target_arch
+	if target_arch == None:
+		target_arch = gdb.execute("show architecture", False, True)
+	return target_arch.find(arch) >= 0
-- 
1.7.3.4

