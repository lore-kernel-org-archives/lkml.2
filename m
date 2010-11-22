Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0KVBJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:09:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35395 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab0KVBDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L19qU3x1KeMIEN+M9Ep5QAKl+U+qGNnVBmHLR5vo42Fl1IWPA70Him6qdUq9NJhFRe
         wL2x4bLvGFdUSrgK01M0tLcEOhsLHuM3FohayPKEGuI/jLBXxC484p3cT7ub1OGwZDiL
         6QCGS0UgJe4xtRVimHtahZ1LbsqBXca5AYV+Y=
From: Tracey Dent <tdent48227@gmail.com>
To: davem@davemloft.net
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
        urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
        sage@newdream.net, ceph-devel@vger.kernel.org, wang840925@gmail.com,
        jlayton@redhat.com, kaber@trash.net, pekkas@netcore.fi,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, samuel@sortiz.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 02/17] Net: caif: Makefile: Remove deprecated items
Date: Sun, 21 Nov 2010 20:03:13 -0500
Message-Id: <1290387808-2239-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
In-Reply-To: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
References: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs
because -objs is deprecated and not mentioned in
Documentation/kbuild/makefiles.txt.

Also, use the ccflags-$ flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched.

Last but not least, took out if-conditionals.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 net/caif/Makefile |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/caif/Makefile b/net/caif/Makefile
index f87481f..9d38e40 100644
--- a/net/caif/Makefile
+++ b/net/caif/Makefile
@@ -1,8 +1,6 @@
-ifeq ($(CONFIG_CAIF_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_CAIF_DEBUG)     :=      -DDEBUG
 
-caif-objs := caif_dev.o \
+caif-y := caif_dev.o \
 	cfcnfg.o cfmuxl.o cfctrl.o  \
 	cffrml.o cfveil.o cfdbgl.o\
 	cfserl.o cfdgml.o  \
@@ -13,4 +11,4 @@ obj-$(CONFIG_CAIF) += caif.o
 obj-$(CONFIG_CAIF_NETDEV) += chnl_net.o
 obj-$(CONFIG_CAIF) += caif_socket.o
 
-export-objs := caif.o
+export-y := caif.o
-- 
1.7.3.2.245.g03276

