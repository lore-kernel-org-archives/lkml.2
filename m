Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab2HIPbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:31:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:15213 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758327Ab2HIPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,740,1336374000"; 
   d="scan'208";a="132004034"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] perf, tools: Add description of JIT interface
Date: Thu,  9 Aug 2012 08:31:00 -0700
Message-Id: <1344526260-18721-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a description of the JIT interface in the perf symbol resolution
code. I reverse engineered the format from the source.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/jit-interface.txt |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/jit-interface.txt

diff --git a/tools/perf/Documentation/jit-interface.txt b/tools/perf/Documentation/jit-interface.txt
new file mode 100644
index 0000000..aa66735
--- /dev/null
+++ b/tools/perf/Documentation/jit-interface.txt
@@ -0,0 +1,16 @@
+perf supports a simple JIT interface to resolve symbols for dynamic code generated
+by a JIT.
+
+The JIT has to write a /tmp/perf-%d.map  (%d = pid of process) file
+
+This is a text file.
+
+Each line has the following format, fields separated with spaces.
+
+START SIZE symbolname
+
+START and SIZE are hex numbers without 0x
+symbolname is the rest of the line, so it could contain special characters.
+
+The ownership of the file has to match the process.
+
-- 
1.7.7.6

