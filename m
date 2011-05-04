Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1EDUuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:50:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:51666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab1EDUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:50:04 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rpm-pkg: Fix when current directory is a symlink
Date: Wed,  4 May 2011 22:49:45 +0200
Message-Id: <1304542185-14520-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The better fix would be to stop using the parent directory (principle of
least surprise), but as long as we use it, use it consistently.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/package/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 1b7eaea..006960e 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -28,7 +28,7 @@ RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
 # Remove hyphens since they have special meaning in RPM filenames
 KERNELPATH := kernel-$(subst -,_,$(KERNELRELEASE))
 MKSPEC     := $(srctree)/scripts/package/mkspec
-PREV       := set -e; cd ..;
+PREV       := set -e; cd -P ..;
 
 # rpm-pkg
 # ---------------------------------------------------------------------------
-- 
1.7.4.1

