Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2KEQJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:09:25 -0500
Received: from goliath.siemens.de ([192.35.17.28]:19150 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2KEQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:09:23 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 13/13] scripts/gdb: Add lx_current convenience function
Date: Mon,  5 Nov 2012 17:09:06 +0100
Message-Id: <dacf8206d5826c5d702dd03aebcf57406912efb1.1352131732.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a shorthand for *$lx_per_cpu("current_task"), i.e. a convenience
function to retrieve the currently running task of the active context.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/percpu.py |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
index 6e24400..ecf72b6 100644
--- a/scripts/gdb/percpu.py
+++ b/scripts/gdb/percpu.py
@@ -59,3 +59,18 @@ class PerCpu(gdb.Function):
 		return per_cpu(var_name.string(), cpu)
 
 PerCpu()
+
+
+class LxCurrentFunc(gdb.Function):
+	__doc__ = "Return current task.\n" \
+		  "\n" \
+		  "$lx_current([CPU]): Return the per-cpu task variable for the given CPU\n" \
+		  "number. If CPU is omitted, the CPU of the current context is used."
+
+	def __init__(self):
+		super(LxCurrentFunc, self).__init__("lx_current")
+
+	def invoke(self, cpu = -1):
+		return per_cpu("current_task", cpu).dereference()
+
+LxCurrentFunc()
-- 
1.7.3.4

