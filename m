Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859Ab2EIWC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:02:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab2EIWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:02:27 -0400
Date: Wed, 9 May 2012 15:01:53 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-c5403aed044e23f8d1ecdf05d0ff120314186527@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, mmarek@suse.cz, jarkko.sakkinen@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, jarkko.sakkinen@intel.com,
        mmarek@suse.cz, hpa@linux.intel.com
In-Reply-To: <1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: build fix:
  remove duplicate build
Git-Commit-ID: c5403aed044e23f8d1ecdf05d0ff120314186527
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 15:01:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5403aed044e23f8d1ecdf05d0ff120314186527
Gitweb:     http://git.kernel.org/tip/c5403aed044e23f8d1ecdf05d0ff120314186527
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Wed, 9 May 2012 23:25:06 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 May 2012 13:32:17 -0700

x86, realmode: build fix: remove duplicate build

Real-mode binary was built twice. This patch fixes
the issue by making realmode.relocs as target for
realmode.bin.

[ hpa: removed the direct dependency on realmode.relocs in
  arch/x86/realmode/Makefile ]

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/Makefile    |    5 +----
 arch/x86/realmode/rm/Makefile |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
index f22a4f8..a05b3ac 100644
--- a/arch/x86/realmode/Makefile
+++ b/arch/x86/realmode/Makefile
@@ -11,10 +11,7 @@ subdir- := rm
 
 obj-y += rmpiggy.o
 
-$(obj)/rmpiggy.o: $(obj)/rm/realmode.relocs $(obj)/rm/realmode.bin
+$(obj)/rmpiggy.o: $(obj)/rm/realmode.bin
 
 $(obj)/rm/realmode.bin: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/rm $@
-
-$(obj)/rm/realmode.relocs: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/rm $@
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index de40bc4..1c1d3d3 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -48,7 +48,7 @@ $(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
 
 OBJCOPYFLAGS_realmode.bin := -O binary
 
-$(obj)/realmode.bin: $(obj)/realmode.elf
+$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
