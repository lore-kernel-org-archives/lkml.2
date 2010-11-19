Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0KSJvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 04:51:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40653 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0KSJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 04:51:08 -0500
Date: Fri, 19 Nov 2010 10:51:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf: Fix compilation on gcc 4.0.2 v2
Message-ID: <20101119095103.GB23515@basil.fritz.box>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
 <1290077461-12321-2-git-send-email-andi@firstfloor.org>
 <1290078937.2109.1345.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290078937.2109.1345.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Updated version, this time using the try-cc command.
I remove the useless -Wvolatile-register-var warning.
I don't think any kernel coder will really do such
a thing in the first place.]

- Fix includes
- Remove useless -Wvolatile-register-var
- Move -Wstack-protector into stack protector test

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d1db0f6..993ecdb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -201,13 +201,11 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
@@ -287,8 +285,8 @@ endif
 
 -include feature-tests.mak
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
-	CFLAGS := $(CFLAGS) -fstack-protector-all
+ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all -Wstack-protector),y)
+	CFLAGS := $(CFLAGS) -fstack-protector-all -Wstack-protector
 endif
 
 
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index bb4ac2e..50ce182 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -1,6 +1,7 @@
 #ifndef _PERF_LINUX_BITOPS_H_
 #define _PERF_LINUX_BITOPS_H_
 
+#include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <asm/hweight.h>
 
-- 
ak@linux.intel.com -- Speaking for myself only.
