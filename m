Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab2K0KQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:16:38 -0500
Received: from david.siemens.de ([192.35.17.14]:31160 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410Ab2K0KME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:04 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>
Subject: [PATCH v3 09/13] scripts/gdb: Add is_target_arch helper
Date: Tue, 27 Nov 2012 11:11:40 +0100
Message-Id: <efef74213b3e84b97a3d0301819ccaf7fd19016a.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
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
index 96f5e1c..7a531d0 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -91,3 +91,12 @@ def read_u64(buffer):
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

