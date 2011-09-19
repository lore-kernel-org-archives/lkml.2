Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1ISOWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:22:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65243 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1ISOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:22:08 -0400
Date: Mon, 19 Sep 2011 22:21:50 +0800
From: Adam Lee <adam8157@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] allow make ARCH="the machine hardware name"
Message-ID: <20110919142150.GA2111@adam-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
X-PGP-Key-ID: D15CA3BE
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch add support for make ARCH="the machine hardware name"(`uname
-m).

UTS_MACHINE is not always the same as SRCARCH, for example, s390x, we
should set UTS_MACHINE=s390x, and SRCARCH=s390. This patch makes that
right when "make ARCH=s390x".

And it avoid some error during invocation of make when ARCH set as
s390x, ppc64 or some machine hardware name else.

Signed-off-by: Adam Lee <adam8157@gmail.com>

--wRRV7LY7NUeQGEoC
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="allow-make-ARCH-the-machine-hardware-name.patch"

---
 Makefile |   41 ++++++++---------------------------------
 1 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/Makefile b/Makefile
index 522fa47..bcbfaba 100644
--- a/Makefile
+++ b/Makefile
@@ -197,44 +197,19 @@ CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
-SRCARCH 	:= $(ARCH)
 
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-        SRCARCH := x86
-endif
-ifeq ($(ARCH),x86_64)
-        SRCARCH := x86
-endif
-
-# Additional ARCH settings for sparc
-ifeq ($(ARCH),sparc32)
-       SRCARCH := sparc
-endif
-ifeq ($(ARCH),sparc64)
-       SRCARCH := sparc
-endif
-
-# Additional ARCH settings for sh
-ifeq ($(ARCH),sh64)
-       SRCARCH := sh
-endif
-
-# Additional ARCH settings for tile
-ifeq ($(ARCH),tilepro)
-       SRCARCH := tile
-endif
-ifeq ($(ARCH),tilegx)
-       SRCARCH := tile
-endif
+# Where arch specific source located
+SRCARCH		:= $(shell echo $(ARCH) | \
+			   sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+			   -e s/arm.*/arm/ -e s/sa110/arm/ \
+			   -e s/m68k.*/m68k/ -e s/mips.*/mips/ \
+			   -e s/parisc64/parisc/ -e s/ppc.*/powerpc/ \
+			   -e s/s390x/s390/ -e s/sh.*/sh/ -e s/sun4u/sparc/ \
+			   -e s/sparc.*/sparc/ -e s/tile.*/tile/ )
 
 # Where to locate arch specific headers
 hdr-arch  := $(SRCARCH)
 
-ifeq ($(ARCH),m68knommu)
-       hdr-arch  := m68k
-endif
-
 KCONFIG_CONFIG	?= .config
 export KCONFIG_CONFIG
 

--wRRV7LY7NUeQGEoC--
