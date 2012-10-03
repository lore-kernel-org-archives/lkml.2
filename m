Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2JCLWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:20 -0400
Received: from mout.web.de ([212.227.15.4]:55773 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab2JCLWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:11 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 09/13] scripts/gdb: Add is_target_arch helper
Date: Wed,  3 Oct 2012 13:21:40 +0200
Message-Id: <132771c0ae3f24b888c8af2dc07557ee6f583509.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:ObdH/Kf4GvONF2kvV7VBuHT+wJ6eTnpSIYrJGD4V7Jt
 tXL2Zysb/mZQpQA/+qVrjmZBfnMVyWU0OUQK3+VCVxEXE1Ju/x
 mFez50rNMrH5REXOfr8g4YsZ1k9Fqubka0eJmW6fTVqtXXdRJF
 c19G+p0Q8BkDCwz2ISWJ4FQJxRoNkWyKRBll60wJ2CfqCQaskl
 hpGbjVC+Fp6xQTT5I1tWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This helper caches to result of "show architecture" and matches the
provided arch (sub-)string against that output.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 17762c5..7c09787 100644
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

