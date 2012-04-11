Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2DKVIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:08:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49834 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761272Ab2DKVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/13] tools: Add a toplevel Makefile
Date: Wed, 11 Apr 2012 18:05:16 -0300
Message-Id: <1334178325-19148-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a Makefile with all the targets under tools/.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-4-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 tools/Makefile

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 0000000..feadfdd
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,47 @@
+include scripts/Makefile.include
+
+cpupower: FORCE
+	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
+
+firewire lguest perf usb virtio vm: FORCE
+	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
+
+selftests: FORCE
+	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
+
+turbostat x86_energy_perf_policy: FORCE
+	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
+
+cpupower_install:
+	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+firewire_install lguest_install perf_install usb_install virtio_install vm_install:
+	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+selftests_install:
+	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) install
+
+turbostat_install x86_energy_perf_policy_install:
+	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+install: cpupower_install firewire_install lguest_install perf_install \
+		selftests_install turbostat_install usb_install virtio_install \
+		vm_install x86_energy_perf_policy_install
+
+cpupower_clean:
+	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
+
+firewire_clean lguest_clean perf_clean usb_clean virtio_clean vm_clean:
+	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+selftests_clean:
+	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+turbostat_clean x86_energy_perf_policy_clean:
+	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+
+clean: cpupower_clean firewire_clean lguest_clean perf_clean selftests_clean \
+		turbostat_clean usb_clean virtio_clean vm_clean \
+		x86_energy_perf_policy_clean
+
+.PHONY: FORCE
-- 
1.7.9.2.358.g22243

