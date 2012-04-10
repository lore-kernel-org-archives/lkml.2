Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab2DJPU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:20:57 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38995 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab2DJPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:20:55 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v4 2/4] tools: Add a toplevel Makefile
Date: Tue, 10 Apr 2012 17:20:38 +0200
Message-Id: <1334071240-28692-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1334071240-28692-1-git-send-email-bp@amd64.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a Makefile with all the targets under tools/.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 tools/Makefile

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 000000000000..e93b8ec3d250
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,31 @@
+include scripts/Makefile.include
+
+perf firewire lguest usb virtio vm: FORCE
+	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
+
+cpupower: FORCE
+	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
+
+turbostat x86_energy_perf_policy: FORCE
+	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
+
+selftests: FORCE
+	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
+
+firewire_clean lguest_clean perf_clean vm_clean usb_clean virtio_clean:
+	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+cp_clean:
+	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
+
+turbostat_clean x86_energy_perf_policy_clean:
+	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+selftests_clean:
+	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+clean: cp_clean firewire_clean lguest_clean perf_clean selftests_clean \
+		turbostat_clean usb_clean virtio_clean \
+		x86_energy_perf_policy_clean
+
+.PHONY: FORCE
-- 
1.7.9.3.362.g71319

