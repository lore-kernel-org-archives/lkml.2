Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0KVBYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:24:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48760 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab0KVBYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U4Z0x4k0xQvVoXlNgJqR9LnjBqaUYjoX5Ktm2YCeTbzhuV4Ao9jfq3ex/gRTgJDVmD
         qg1LtJCdrcOer+NyOE2yhAEeZetC83XwiPXBe9LTPfB8MA8smHDArUP9Eg1OOALgtdvg
         ZW8SdVfYz4fQA/IhqAh6TCgzf6RQzpnF6VFsg=
From: Tracey Dent <tdent48227@gmail.com>
To: sage@newdream.net
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Net: ceph: Makefile: Remove unnessary code
Date: Sun, 21 Nov 2010 20:23:50 -0500
Message-Id: <1290389030-2743-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the if and else conditional because the code is in mainline and there
is no need in it being there.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 net/ceph/Makefile |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/net/ceph/Makefile b/net/ceph/Makefile
index 153bdec..e87ef43 100644
--- a/net/ceph/Makefile
+++ b/net/ceph/Makefile
@@ -1,9 +1,6 @@
 #
 # Makefile for CEPH filesystem.
 #
-
-ifneq ($(KERNELRELEASE),)
-
 obj-$(CONFIG_CEPH_LIB) += libceph.o
 
 libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
@@ -16,22 +13,3 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
 	ceph_fs.o ceph_strings.o ceph_hash.o \
 	pagevec.o
 
-else
-#Otherwise we were called directly from the command
-# line; invoke the kernel build system.
-
-KERNELDIR ?= /lib/modules/$(shell uname -r)/build
-PWD := $(shell pwd)
-
-default: all
-
-all:
-	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_LIB=m modules
-
-modules_install:
-	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_LIB=m modules_install
-
-clean:
-	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
-
-endif
-- 
1.7.3.2.245.g03276

