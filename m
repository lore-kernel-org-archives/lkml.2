Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab1ANOTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:19:52 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:41816
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757748Ab1ANOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:23 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 09:19:09 EST
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 11/27] xtensa: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:34 -0800
Message-Id: <9e01720a9d8455b3ddd7a84465ed8ef700d0e857.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 arch/xtensa/boot/Makefile     |    2 +-
 arch/xtensa/boot/lib/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
index 8657c62..068f143 100644
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
1.7.3.4

