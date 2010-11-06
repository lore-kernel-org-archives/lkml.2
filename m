Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0KFTFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:05:33 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:45602 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab0KFTFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:05:32 -0400
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: [PATCH] kbuild, deb-pkg: support overriding userland architecture
Date: Sat,  6 Nov 2010 19:05:20 +0000
Message-Id: <1289070320-20726-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4CD5A6C8.8030603@asbjorn.biz>
References: <4CD5A6C8.8030603@asbjorn.biz>
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

This patch is based on my 'kbuild, deb-pkg: select
userland architecture based on UTS_MACHINE' patch.

LKML-reference: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
---
 scripts/package/builddeb |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 0043ccd..4772a73 100644
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

