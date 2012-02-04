Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2BDJ4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 04:56:48 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41686 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab2BDJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 04:56:46 -0500
From: Gerard Snitselaar <dev@snitselaar.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Kbuild: Makefile: clean up samples directory
Date: Sat,  4 Feb 2012 02:55:59 -0700
Message-Id: <1328349359-29524-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Playing around with make randconfig I ended up with CONFIG_SAMPLES
set. After cleaning up the build I noticed that git status was
showing samples/hidraw/hid-example as an untracked file.

Adding samples to clean-dirs seems to solve the problem, but
I don't know if that is the correct way to solve the issue.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index e3b23e8..0a83480 100644
--- a/Makefile
+++ b/Makefile
@@ -1170,7 +1170,7 @@ MRPROPER_FILES += .config .config.old .version .old_version             \
 #
 clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
-clean-dirs      := $(addprefix _clean_, . $(vmlinux-alldirs) Documentation)
+clean-dirs      := $(addprefix _clean_, . $(vmlinux-alldirs) Documentation samples)
 
 PHONY += $(clean-dirs) clean archclean
 $(clean-dirs):
-- 
1.7.7.6

