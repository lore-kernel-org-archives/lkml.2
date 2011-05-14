Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1ENK5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63692 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1ENK4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rrszQGOkBNjqLjCzTbISbCu2fTTy5mxYUuTurc655HiAJPwtfJim2fnRw9xGrgxYdG
         xAWjxadg6Uw06gAWG20gTTSP4lXdTSHsVCAHn1IarRQf/Nx+5oHHZr0yMUxTWyrlhHw2
         yjA+Pd66aBeiNbj56Su7cXcyI3XRHzgmrsUKQ=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] package: Makefile: add USB/IP userspace utilities
Date: Sat, 14 May 2011 03:55:20 -0700
Message-Id: <5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Add usbip-src-pkg target to generate a tarball of the userspace source.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 scripts/package/Makefile |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index a834b93..c736a12 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -134,6 +134,19 @@ $(error unknown target $@))))                                       \
 perf-%pkg: FORCE
 	$(call cmd,perf_tar)
 
+# usbip-src-pkg - generate a source tarball of USB/IP userspace utilities
+# ---------------------------------------------------------------------------
+usbip-pkg := usbip-$(KERNELVERSION)
+usbip-userspace := $(srctree)/drivers/staging/usbip/userspace
+
+quiet_cmd_usbip_pkg = TAR  $(usbip-pkg)
+      cmd_usbip_pkg = \
+		tar czfP $(usbip-pkg).tar.gz $(usbip-userspace)	\
+			--transform="s:$(usbip-userspace):$(usbip-pkg):"
+
+usbip-src-pkg: FORCE
+	$(call cmd,usbip_pkg)
+
 # Help text displayed when executing 'make help'
 # ---------------------------------------------------------------------------
 help: FORCE
@@ -148,4 +161,4 @@ help: FORCE
 	@echo '  perf-targz-src-pkg  - Build $(perf-tar).tar.gz source tarball'
 	@echo '  perf-tarbz2-src-pkg - Build $(perf-tar).tar.bz2 source tarball'
 	@echo '  perf-tarxz-src-pkg  - Build $(perf-tar).tar.xz source tarball'
-
+	@echo '  usbip-src-pkg       - Build source tarball of USB/IP userspace utilities'
-- 
1.7.5.1

