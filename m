Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0LLRsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 12:48:07 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:37935 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab0LLRsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 12:48:04 -0500
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: [PATCH v4] kbuild, deb-pkg: support overriding userland architecture
Date: Sun, 12 Dec 2010 17:39:40 +0000
Message-Id: <1292175580-22085-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4D00F709.1000406@suse.cz>
References: <4D00F709.1000406@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usefull if building for sparc64 userland, because the
sparc and sparc64 userlands use the same 64-bit kernel,
making it impossible to always select the correct userland
architecture for the resulting debian package.

Might also be usefull, if you want a i386 userland with a amd64 kernel.

Example usage:
	make KBUILD_DEBARCH=i386 deb-pkg

LKML-reference: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: maximilian attems <max@stro.at>
---
 Documentation/kbuild/kbuild.txt |    8 ++++++++
 scripts/package/builddeb        |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 634c625..b146eb8 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -51,6 +51,14 @@ Specify the output directory when building the kernel.
 The output directory can also be specificed using "O=...".
 Setting "O=..." takes precedence over KBUILD_OUTPUT.
 
+KBUILD_DEBARCH
+--------------------------------------------------
+For the deb-pkg target, allows overriding the normal heuristics deployed by
+deb-pkg. Normally deb-pkg attempts to guess the right architecture based on
+the UTS_MACHINE variable, and on some architectures also the kernel config.
+The value of KBUILD_DEBARCH is assumed (not checked) to be a valid Debian
+architecture.
+
 ARCH
 --------------------------------------------------
 Set ARCH to the architecture to be built.
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5d6be3f..ffe2419 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -54,6 +54,9 @@ create_package() {
 		echo "Please add support for $UTS_MACHINE to ${0} ..." >&2
 		echo "" >&2
 	esac
+	if [ -n "$KBUILD_DEBARCH" ] ; then
+		debarch="$KBUILD_DEBARCH"
+	fi
 	if [ -n "$debarch" ] ; then
 		forcearch="-DArchitecture=$debarch"
 	fi
-- 
1.7.2.3

