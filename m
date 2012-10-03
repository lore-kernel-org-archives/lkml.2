Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2JCLWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:05 -0400
Received: from mout.web.de ([212.227.17.12]:56169 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2JCLWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:00 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 13/13] scripts/gdb: Add lx_current convenience function
Date: Wed,  3 Oct 2012 13:21:44 +0200
Message-Id: <84526625a883517733e6d5f856ac87b2b86842fb.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:N36Prhcvm6VVvj3cbwg/+oGd94sMwtwX5KWtvt7GSWt
 iNx/E6Ra0PPcKSS5BzsbAvdK90IaVG/dy94rGNArSRay/p1gm4
 k5hNwGGr4Y3Ue3r1zJS6jRzihTj/+Ru6sTC0k/unDwvjoiq5Ml
 7jMgiA8s9ALZAVdUKwZfg36Jfz9gQHWNk9zTSP6UNrFjxTh+9R
 XPDxKXTiuYEte/HeAlkuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

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

