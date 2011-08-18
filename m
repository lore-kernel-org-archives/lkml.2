Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1HRFVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab1HRFU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:20:58 -0400
From: WANG Cong <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-doc@vger.kernel.org
Subject: [Patch] x86: remove i386/x86_64 bzImage symlinks
Date: Thu, 18 Aug 2011 13:19:55 +0800
Message-Id: <1313644795-27628-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These symlinks are unnecessary and scheduled to be removed
for a long time.

I test this patch on Fedora, nothing breaks, but I am not
sure about other distros.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c4a6e14..cf59e83 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -253,16 +253,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
-What:	i386/x86_64 bzImage symlinks
-When:	April 2010
-
-Why:	The i386/x86_64 merge provides a symlink to the old bzImage
-	location so not yet updated user space tools, e.g. package
-	scripts, do not break.
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	GPIO autorequest on gpio_direction_{input,output}() in gpiolib
 When:	February 2010
 Why:	All callers should use explicit gpio_request()/gpio_free().
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b02e509..5401a3c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -162,8 +162,6 @@ ifeq ($(CONFIG_X86_DECODER_SELFTEST),y)
 	$(Q)$(MAKE) $(build)=arch/x86/tools posttest
 endif
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
-	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/$@
 
 $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $@
