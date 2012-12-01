Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2LALPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:15:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LALPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:15:43 -0500
Date: Sat, 1 Dec 2012 03:15:11 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-ca9dfc6cc45a8ae0297188f5fed23af242cc8a8d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        namhyung@gmail.com, bp@amd64.org, dhowells@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, bp@amd64.org, namhyung@gmail.com,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <1378.1352379110@warthog.procyon.org.uk>
References: <1378.1352379110@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools:
  Define a Makefile function to do subdir processing
Git-Commit-ID: ca9dfc6cc45a8ae0297188f5fed23af242cc8a8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 01 Dec 2012 03:15:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca9dfc6cc45a8ae0297188f5fed23af242cc8a8d
Gitweb:     http://git.kernel.org/tip/ca9dfc6cc45a8ae0297188f5fed23af242cc8a8d
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Mon, 5 Nov 2012 15:15:24 +0000
Committer:  David Howells <dhowells@redhat.com>
CommitDate: Mon, 19 Nov 2012 22:10:14 +0000

tools: Define a Makefile function to do subdir processing

Define a Makefile function that can be called with $(call ...) to wrap
the subdir make invocations in tools/Makefile.

This will allow us in the next patch to insert bits in there to honour
O= flags when called from the top-level Makefile.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1378.1352379110@warthog.procyon.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile                 | 24 ++++++++++++------------
 tools/scripts/Makefile.include |  8 ++++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/Makefile b/tools/Makefile
index 3ae4394..1f9a529 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -31,44 +31,44 @@ help:
 	@echo '  clean: a summary clean target to clean _all_ folders'
 
 cpupower: FORCE
-	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
+	$(call descend,power/$@)
 
 firewire lguest perf usb virtio vm: FORCE
-	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
+	$(call descend,$@)
 
 selftests: FORCE
-	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
+	$(call descend,testing/$@)
 
 turbostat x86_energy_perf_policy: FORCE
-	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
+	$(call descend,power/x86/$@)
 
 cpupower_install:
-	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,power/$(@:_install=),install)
 
 firewire_install lguest_install perf_install usb_install virtio_install vm_install:
-	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,$(@:_install=),install)
 
 selftests_install:
-	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) install
+	$(call descend,testing/$(@:_clean=),install)
 
 turbostat_install x86_energy_perf_policy_install:
-	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,power/x86/$(@:_install=),install)
 
 install: cpupower_install firewire_install lguest_install perf_install \
 		selftests_install turbostat_install usb_install virtio_install \
 		vm_install x86_energy_perf_policy_install
 
 cpupower_clean:
-	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
+	$(call descend,power/cpupower,clean)
 
 firewire_clean lguest_clean perf_clean usb_clean virtio_clean vm_clean:
-	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,$(@:_clean=),clean)
 
 selftests_clean:
-	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,testing/$(@:_clean=),clean)
 
 turbostat_clean x86_energy_perf_policy_clean:
-	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,power/x86/$(@:_clean=),clean)
 
 clean: cpupower_clean firewire_clean lguest_clean perf_clean selftests_clean \
 		turbostat_clean usb_clean virtio_clean vm_clean \
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 96ce80a..4a9e317 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -41,6 +41,14 @@ else
 NO_SUBDIR = :
 endif
 
+#
+# Define a callable command for descending to a new directory
+#
+# Call by doing: $(call descend,directory[,target])
+#
+descend = \
+	$(QUIET_SUBDIR0)$(1) $(QUIET_SUBDIR1) $(2)
+
 QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
