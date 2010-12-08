Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0LHVgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:36:06 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:34024 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0LHVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:05 -0500
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: [PATCH v2] kbuild, deb-pkg: support overriding userland architecture
Date: Wed,  8 Dec 2010 21:35:50 +0000
Message-Id: <1291844150-4541-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101125143739.GC8192@sepie.suse.cz>
References: <20101125143739.GC8192@sepie.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usefull if building for sparc64 userland, because the
sparc and sparc64 userlands use the same 64-bit kernel,
making it impossible to always select the correct userland
architecture for the resulting debian package.

Might also be usefull, if you want a i386 userland with a amd64 kernel.

Example usage:
	make DEBARCH=i386 deb-pkg

LKML-reference: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: maximilian attems <max@stro.at>
---
 Documentation/kbuild/kbuild.txt |    8 ++++++++
 scripts/package/builddeb        |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 634c625..2940df0 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -60,6 +60,14 @@ But some architectures such as x86 and sparc have aliases.
 x86: i386 for 32 bit, x86_64 for 64 bit
 sparc: sparc for 32 bit, sparc64 for 64 bit
 
+DEBARCH
+--------------------------------------------------
+For the deb-pkg target, allows overriding the normal heuristics deployed by
+deb-deb. Normally deb-pkg attempts to guess the right architecture based on
+the UTS_MACHINE variable, and on some architectures also the kernel config.
+The value of DEBARCH is assumed (not checked) to be a valid Debian
+architecture.
+
 CROSS_COMPILE
 --------------------------------------------------
 Specify an optional fixed part of the binutils filename.
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5d6be3f..22b6995 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -54,6 +54,9 @@ create_package() {
 		echo "Please add support for $UTS_MACHINE to ${0} ..." >&2
 		echo "" >&2
 	esac
+	if [ -n "$DEBARCH" ] ; then
+		debarch="$DEBARCH"
+	fi
 	if [ -n "$debarch" ] ; then
 		forcearch="-DArchitecture=$debarch"
 	fi
-- 
1.7.2.3

