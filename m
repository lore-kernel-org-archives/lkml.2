Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2DMSSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:18:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2DMSSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:18:51 -0400
Date: Fri, 13 Apr 2012 11:18:00 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-ea01fa9f63aeff3ac918868217aa94adf76ddcc7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, sam@ravnborg.org, tglx@linutronix.de, mmarek@suse.cz,
        borislav.petkov@amd.com
In-Reply-To: <1334162178-17152-6-git-send-email-bp@amd64.org>
References: <1334162178-17152-6-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools: Connect to the kernel build system
Git-Commit-ID: ea01fa9f63aeff3ac918868217aa94adf76ddcc7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:18:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea01fa9f63aeff3ac918868217aa94adf76ddcc7
Gitweb:     http://git.kernel.org/tip/ea01fa9f63aeff3ac918868217aa94adf76ddcc7
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 11 Apr 2012 18:36:18 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 15:00:17 -0300

tools: Connect to the kernel build system

Now you can do

$ make tools/<toolname>

from the toplevel kernel directory and have the respective tool built.

If you want to build and install it, do

$ make tools/<toolname>_install

$ make tools/<toolname>_clean

should clean the respective tool directories.

If you want to clean all in tools, simply do

$ make tools/clean

Also, if you want to get what the possible targets are, simply calling

$ make tools/

should give you the short help.

$ make tools/install

installs all tools, of course. Doh.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-6-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile       |    7 +++++++
 tools/Makefile |   10 ++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 1932984..23b9ce5 100644
--- a/Makefile
+++ b/Makefile
@@ -1468,6 +1468,13 @@ kernelrelease:
 kernelversion:
 	@echo $(KERNELVERSION)
 
+# Clear a bunch of variables before executing the submake
+tools/: FORCE
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
+
+tools/%: FORCE
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+
 # Single targets
 # ---------------------------------------------------------------------------
 # Single targets are compatible with:
diff --git a/tools/Makefile b/tools/Makefile
index f87c0ec..3ae4394 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -14,6 +14,16 @@ help:
 	@echo '  vm         - misc vm tools'
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
+	@echo 'You can do:'
+	@echo ' $$ make -C tools/<tool>_install'
+	@echo ''
+	@echo '  from the kernel command line to build and install one of'
+	@echo '  the tools above'
+	@echo ''
+	@echo '  $$ make tools/install'
+	@echo ''
+	@echo '  installs all tools.'
+	@echo ''
 	@echo 'Cleaning targets:'
 	@echo ''
 	@echo '  all of the above with the "_clean" string appended cleans'
