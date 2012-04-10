Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2DJPVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:21:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39005 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab2DJPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:20:55 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v4 3/4] tools: Add a help target
Date: Tue, 10 Apr 2012 17:20:39 +0200
Message-Id: <1334071240-28692-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1334071240-28692-1-git-send-email-bp@amd64.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... and make it the default one so that calling 'make' without arguments
in the tools/ directory gives you the possible targets to build along
with a short description of what they are.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/Makefile b/tools/Makefile
index e93b8ec3d250..c7ed814e12cf 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -1,5 +1,25 @@
 include scripts/Makefile.include
 
+help:
+	@echo 'Possible targets:'
+	@echo ''
+	@echo '  cpupower   - a tool for all things x86 CPU power'
+	@echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
+	@echo '  lguest     - a minimal 32-bit x86 hypervisor'
+	@echo '  perf       - Linux performance measurement and analysis tool'
+	@echo '  selftests  - various kernel selftests'
+	@echo '  turbostat  - Intel CPU idle stats and freq reporting tool'
+	@echo '  usb        - USB testing tools'
+	@echo '  virtio     - vhost test module'
+	@echo '  vm         - misc vm tools'
+	@echo '  x86_energy_perf_policy - Intel energy policy tool'
+	@echo ''
+	@echo 'Cleaning targets:'
+	@echo ''
+	@echo '  all of the above with the "_clean" string appended cleans'
+	@echo '    the respective build directory.'
+	@echo '  clean: a summary clean target to clean _all_ folders'
+
 perf firewire lguest usb virtio vm: FORCE
 	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
 
@@ -15,7 +35,7 @@ selftests: FORCE
 firewire_clean lguest_clean perf_clean vm_clean usb_clean virtio_clean:
 	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-cp_clean:
+cpupower_clean:
 	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
 
 turbostat_clean x86_energy_perf_policy_clean:
@@ -24,8 +44,8 @@ turbostat_clean x86_energy_perf_policy_clean:
 selftests_clean:
 	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-clean: cp_clean firewire_clean lguest_clean perf_clean selftests_clean \
-		turbostat_clean usb_clean virtio_clean \
+clean: cpupower_clean firewire_clean lguest_clean perf_clean \
+		selftests_clean turbostat_clean usb_clean virtio_clean \
 		x86_energy_perf_policy_clean
 
 .PHONY: FORCE
-- 
1.7.9.3.362.g71319

