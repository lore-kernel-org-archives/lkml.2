Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2HMSiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:38:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49411 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2HMShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 38/38] perf symbols: Add description of JIT interface
Date: Mon, 13 Aug 2012 15:37:19 -0300
Message-Id: <1344883039-13495-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a description of the JIT interface in the perf symbol resolution
code. I reverse engineered the format from the source.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Link: http://lkml.kernel.org/r/1344526260-18721-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/jit-interface.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/jit-interface.txt

diff --git a/tools/perf/Documentation/jit-interface.txt b/tools/perf/Documentation/jit-interface.txt
new file mode 100644
index 0000000..a8656f5
--- /dev/null
+++ b/tools/perf/Documentation/jit-interface.txt
@@ -0,0 +1,15 @@
+perf supports a simple JIT interface to resolve symbols for dynamic code generated
+by a JIT.
+
+The JIT has to write a /tmp/perf-%d.map  (%d = pid of process) file
+
+This is a text file.
+
+Each line has the following format, fields separated with spaces:
+
+START SIZE symbolname
+
+START and SIZE are hex numbers without 0x.
+symbolname is the rest of the line, so it could contain special characters.
+
+The ownership of the file has to match the process.
-- 
1.7.1

