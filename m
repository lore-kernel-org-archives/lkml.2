Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2HSDCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:36894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab2HSC5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422078"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 62/74] Kbuild, lto: add ld-version and ld-ifversion macros
Date: Sat, 18 Aug 2012 19:56:58 -0700
Message-Id: <1345345030-22211-63-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

To check the linker version. Used by the LTO makefile.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/Kbuild.include |    9 +++++++++
 scripts/ld-version.sh  |    8 ++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100755 scripts/ld-version.sh

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 6a3ee98..bda5b20 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -155,6 +155,15 @@ ld-option = $(call try-run,\
 # Important: no spaces around options
 ar-option = $(call try-run, $(AR) rc$(1) "$$TMP",$(1),$(2))
 
+# ld-version
+# Usage: $(call ld-version)
+# Note this is mainly for HJ Lu's 3 number binutil versions
+ld-version = $(shell $(LD) --version | $(srctree)/scripts/ld-version.sh)
+
+# ld-ifversion
+# Usage:  $(call ld-ifversion, -ge, 22252, y)
+ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
+
 ######
 
 ###
diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
new file mode 100755
index 0000000..7eb0b76
--- /dev/null
+++ b/scripts/ld-version.sh
@@ -0,0 +1,8 @@
+#!/usr/bin/awk -f
+# extra linker version number from stdin and turn into single number
+	{ 
+	gsub(".*)", ""); 
+	split($1,a, "."); 
+	print a[1]*10000000 + a[2]*100000 + a[3]*10000 + a[4]*100 + a[5]; 
+	exit 
+	}
-- 
1.7.7.6

