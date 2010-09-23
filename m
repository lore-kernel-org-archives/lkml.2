Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0IWGwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:13 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:50666 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab0IWGwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:07 -0400
From: matt mooney <mfm@muteddisk.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/20] s390: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:17 -0700
Message-Id: <1285224677-29899-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/s390/boot/Makefile     |    2 +-
 arch/s390/kvm/Makefile      |    2 +-
 arch/s390/math-emu/Makefile |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 8800cf09..635d677 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -6,7 +6,7 @@ COMPILE_VERSION := __linux_compile_version_id__`hostname |  \
 			tr -c '[0-9A-Za-z]' '_'`__`date | \
 			tr -c '[0-9A-Za-z]' '_'`_t
 
-EXTRA_CFLAGS  := -DCOMPILE_VERSION=$(COMPILE_VERSION) -gstabs -I.
+ccflags-y  := -DCOMPILE_VERSION=$(COMPILE_VERSION) -gstabs -I.
 
 targets := image
 targets += bzImage
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index e5221ec..860d265 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -8,7 +8,7 @@
 
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
-EXTRA_CFLAGS += -Ivirt/kvm -Iarch/s390/kvm
+ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-objs := $(common-objs) kvm-s390.o sie64a.o intercept.o interrupt.o priv.o sigp.o diag.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/math-emu/Makefile b/arch/s390/math-emu/Makefile
index c848903..51d3995 100644
--- a/arch/s390/math-emu/Makefile
+++ b/arch/s390/math-emu/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_MATHEMU) := math.o
 
-EXTRA_CFLAGS := -I$(src) -Iinclude/math-emu -w
+ccflags-y := -I$(src) -Iinclude/math-emu -w
-- 
1.7.2.1

