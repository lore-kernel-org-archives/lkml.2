Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0IWGwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:36 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:59753 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183Ab0IWGwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:33 -0400
From: matt mooney <mfm@muteddisk.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 18/20] xtensa: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:42 -0700
Message-Id: <1285224702-30069-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/xtensa/boot/Makefile     |    2 +-
 arch/xtensa/boot/lib/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
index 40aa55b4..70fd145 100644
--- a/arch/xtensa/boot/Makefile
+++ b/arch/xtensa/boot/Makefile
@@ -14,7 +14,7 @@ HOSTFLAGS	+= -Iarch/$(ARCH)/boot/include
 
 BIG_ENDIAN	:= $(shell echo -e __XTENSA_EB__ | $(CC) -E - | grep -v "\#")
 
-export EXTRA_CFLAGS
+export ccflags-y
 export BIG_ENDIAN
 
 subdir-y	:= lib
diff --git a/arch/xtensa/boot/lib/Makefile b/arch/xtensa/boot/lib/Makefile
index d3d2aa2..ad8952e 100644
--- a/arch/xtensa/boot/lib/Makefile
+++ b/arch/xtensa/boot/lib/Makefile
@@ -6,7 +6,7 @@ zlib	:= inffast.c inflate.c inftrees.c
 
 lib-y	+= $(zlib:.c=.o) zmem.o
 
-EXTRA_CFLAGS	+= -Ilib/zlib_inflate
+ccflags-y	:= -Ilib/zlib_inflate
 
 quiet_cmd_copy_zlib = COPY    $@
       cmd_copy_zlib = cat $< > $@
-- 
1.7.2.1

