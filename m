Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2EGLBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:01:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2EGLB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:01:28 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: gregkh@linuxfoundation.org, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2] ramster: depend on NET for sock_* functions
Date: Mon,  7 May 2012 13:02:22 +0200
Message-Id: <1336388542-8624-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building ramster without NET would cause linkage issue due to missing
sock_*() functions in cluster/tcp.c

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/staging/ramster/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
index 4af1f8d..8e334cb 100644
--- a/drivers/staging/ramster/Kconfig
+++ b/drivers/staging/ramster/Kconfig
@@ -1,6 +1,6 @@
 config RAMSTER
 	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
-	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM
+	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && NET
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
-- 
1.7.8.5

