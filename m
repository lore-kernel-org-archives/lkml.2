Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2JCLYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:24:49 -0400
Received: from mout.web.de ([212.227.15.3]:58612 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2JCLWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:00 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 05/13] scripts/gdb: Add read_u16/32/64 helpers
Date: Wed,  3 Oct 2012 13:21:36 +0200
Message-Id: <886cf0d525fb580867f2172ee485d16a68550cff.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:P2qGb/nLlJwQNEfVpaYCv2QzfxqkEdU5WDzf1wtVH8l
 yn4Pv5FlOS+yPjEzB1nAzJYIlEukCcSAnXcGkZ3ewje8YNlaDU
 dBE5FiWjr23xjBakq2vwxFNtycwy2j4LwL2HE89shBiky7Ow/6
 ZFzh9DLkSGzt4jPHQv0aIHjvY3AN7BM7rXXYpLOtGgyH2UyHd2
 BC8N+3FfMGQ48hHm8+QAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Add helpers for reading integers from target memory buffers. Required
when caching the memory access is more efficient than reading individual
values via gdb.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 40356d9..17762c5 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -70,3 +70,21 @@ def get_target_endianness():
 		else:
 			raise gdb.GdgError("unknown endianness '%s'" % endian)
 	return target_endianness
+
+def read_u16(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return ord(buffer[0]) + (ord(buffer[1]) << 8)
+	else:
+		return ord(buffer[1]) + (ord(buffer[0]) << 8)
+
+def read_u32(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return read_u16(buffer[0:2]) + (read_u16(buffer[2:4]) << 16)
+	else:
+		return read_u16(buffer[2:4]) + (read_u16(buffer[0:2]) << 16)
+
+def read_u64(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
+	else:
+		return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
-- 
1.7.3.4

