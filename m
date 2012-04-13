Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2DMSSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:18:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2DMSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:18:40 -0400
Date: Fri, 13 Apr 2012 11:16:23 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-2363ecb17041d711fa2b3fb1b1ea2ebc47a0f974@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, sam@ravnborg.org, tglx@linutronix.de, mmarek@suse.cz,
        borislav.petkov@amd.com
In-Reply-To: <1334162178-17152-4-git-send-email-bp@amd64.org>
References: <1334162178-17152-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools: Add a toplevel Makefile
Git-Commit-ID: 2363ecb17041d711fa2b3fb1b1ea2ebc47a0f974
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:16:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2363ecb17041d711fa2b3fb1b1ea2ebc47a0f974
Gitweb:     http://git.kernel.org/tip/2363ecb17041d711fa2b3fb1b1ea2ebc47a0f974
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 11 Apr 2012 18:36:16 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 14:58:43 -0300

tools: Add a toplevel Makefile

Add a Makefile with all the targets under tools/.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-4-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

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
