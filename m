Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2JWIFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:05:10 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33944 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab2JWIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:05:01 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz17326ah8275bhz2dh668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1155h)
X-WSS-ID: 0MCC6FZ-02-2M2-02
X-M-MSG: 
From: <steffen.schwigon@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <ss5@renormalist.net>, <srostedt@redhat.com>,
        <Dariusz.Filipski@comarch.com>, <yoshitake.kobayashi@toshiba.co.jp>,
        <sassmann@redhat.com>, <andre.przywara@amd.com>,
        <frank.arnold@amd.com>, <conny.seidel@amd.com>, <csd@broadcom.com>,
        Steffen Schwigon <steffen.schwigon@amd.com>
Subject: [PATCH 2/2] A common test subdirectory
Date: Tue, 23 Oct 2012 10:03:02 +0200
Message-ID: <1350979382-19983-3-git-send-email-steffen.schwigon@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350979382-19983-1-git-send-email-steffen.schwigon@amd.com>
References: <1350979382-19983-1-git-send-email-steffen.schwigon@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Schwigon <steffen.schwigon@amd.com>

This commit introduces t/ as a subdirectory for placing
tests that can be run via the existing Linux tool
'prove' (available in all major Linux distributions).

Tests in there are assumed to produce TAP, the "Test
Anything Protocol" (see http://testanything.org).

A library with special utilities to write TAP tests for
Linux (inclusive KVM and Xen support) is provided in the
previous commit ('bash-test-utils'). TAP libraries are
available for many programming languages. The autotest
project already provides TAP support.

Signed-off-by: Steffen Schwigon <steffen.schwigon@amd.com>
---
 t/examples/basic.t |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100755 t/examples/basic.t

diff --git a/t/examples/basic.t b/t/examples/basic.t
new file mode 100755
index 0000000..d776108
--- /dev/null
+++ b/t/examples/basic.t
@@ -0,0 +1,49 @@
+#!/bin/bash
+
+############################################################
+#
+# t/examples/basic.t
+#
+# An example test script for bash-test-utils
+#
+# Run it with:
+#
+#   $ cd $LINUX_SRC_DIR
+#   $ prove -v t/examples/basic.t
+#
+############################################################
+
+. ./tools/testing/tap/bash-test-utils
+
+uname -a | grep -q Linux  # example for ok exit code
+ok $? "we run on Linux"
+
+# require_* functions gracefully exit if requirements not met
+require_cpufeature "msr"
+require_cpufeature "fpu"
+
+# store success in variables and make complex tests
+if grep -q sse2 /proc/cpuinfo ; then
+    success=0
+else
+    success=1
+fi
+
+# ok() evaluates arg 1 with exit code shell boolean semantics
+# and creates TAP
+ok $success "SSE2 in cpuinfo"
+
+# negate_ok() reverses the success semantics of ok()
+grep -q impossible-value /proc/cpuinfo
+negate_ok $? "no impossible-value in cpuinfo"
+
+# mark tests with "# TODO" at end of description
+# for test driven development
+grep -q not-yet-implemented-detail /proc/cpuinfo
+ok $? "example that fails expectedly # TODO some todo explanation"
+
+# append key:value lines to track values
+bogomips=$(grep -i bogomips /proc/cpuinfo | head -1 | cut -d: -f2)
+append_tapdata "bogomips: $(echo $bogomips)"
+
+done_testing
-- 
1.7.10.4


