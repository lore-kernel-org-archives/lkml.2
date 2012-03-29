Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab2C2M02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:26:28 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60799 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2C2M0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:26:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/4] tools: Add a toplevel Makefile
Date: Thu, 29 Mar 2012 14:25:55 +0200
Message-Id: <1333023957-22746-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1333023957-22746-1-git-send-email-bp@amd64.org>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a Makefile with all the targets under tools/. Also, and add a
minimalistic Makefile to slub/ for completeness.

Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile      |   24 ++++++++++++++++++++++++
 tools/slub/Makefile |    4 ++++
 2 files changed, 28 insertions(+)
 create mode 100644 tools/Makefile
 create mode 100644 tools/slub/Makefile

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 000000000000..134b3604b0b3
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,24 @@
+include scripts/Makefile.include
+
+perf firewire lguest slub usb virtio: FORCE
+	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
+
+cpupower: FORCE
+	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
+
+turbostat x86_energy_perf_policy: FORCE
+	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
+
+firewire_clean lguest_clean perf_clean slub_clean usb_clean virtio_clean:
+	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+cp_clean:
+	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
+
+turbostat_clean x86_energy_perf_policy_clean:
+	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+clean: cp_clean firewire_clean lguest_clean perf_clean slub_clean turbostat_clean \
+		usb_clean virtio_clean x86_energy_perf_policy_clean
+
+.PHONY: FORCE
diff --git a/tools/slub/Makefile b/tools/slub/Makefile
new file mode 100644
index 000000000000..b2cf6b467bbe
--- /dev/null
+++ b/tools/slub/Makefile
@@ -0,0 +1,4 @@
+slabinfo: slabinfo.c
+
+clean:
+	rm -rf slabinfo
-- 
1.7.9.3.362.g71319

