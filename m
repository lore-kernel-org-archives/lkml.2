Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2KEQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:09:27 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23876 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab2KEQJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:09:23 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 04/13] scripts/gdb: Add get_target_endianness helper
Date: Mon,  5 Nov 2012 17:08:57 +0100
Message-Id: <d5266c90a6e8c78d6d7331d91b806c06e5446138.1352131730.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the target endianness from the output of "show endian" and cache
the result to return it via the new helper get_target_endiannes. We will
need it for reading integers from buffers that contain target memory.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 74682c3..a4e6df2 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -53,3 +53,20 @@ class ContainerOf(gdb.Function):
 				    elementname.string())
 
 ContainerOf()
+
+
+BIG_ENDIAN = 0
+LITTLE_ENDIAN = 1
+target_endianness = None
+
+def get_target_endianness():
+	global target_endianness
+	if target_endianness == None:
+		endian = gdb.execute("show endian", False, True)
+		if endian.find("little endian") >= 0:
+			target_endianness = LITTLE_ENDIAN
+		elif endian.find("big endian") >= 0:
+			target_endianness = BIG_ENDIAN
+		else:
+			raise gdb.GdgError("unknown endianness '%s'" % endian)
+	return target_endianness
-- 
1.7.3.4

