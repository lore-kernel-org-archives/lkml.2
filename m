Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2JCLWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:11 -0400
Received: from mout.web.de ([212.227.15.3]:53934 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab2JCLWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:08 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 04/13] scripts/gdb: Add get_target_endianness helper
Date: Wed,  3 Oct 2012 13:21:35 +0200
Message-Id: <4f794cfb44b8c19fe97333677d89018b023be341.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:ChTdLexWJBCUIQeU0eVXELKz2t2+CItysxU1FQqkkSu
 iMdoDnryLVNNJg5Y+m758XDg8ndR0pxMt+Tc7kx2w4DKiEniHL
 dy8uBE8IsUYwyksZSV3m/KZrgoOQoMRppfRa2KHXq8Ux9ynnov
 wzWGYPYERjliHG3l2ZM6Q03PxYxjIBUCO3eBfzL1QuJlYC3J4J
 +XvVQkp0RQs/4syqbYI8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Parse the target endianness from the output of "show endian" and cache
the result to return it via the new helper get_target_endiannes. We will
need it for reading integers from buffers that contain target memory.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index f770c5c..40356d9 100644
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

