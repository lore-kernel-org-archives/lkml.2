Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab1ANOTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:19:38 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:40996
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757786Ab1ANOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:25 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 09/27] s390: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:32 -0800
Message-Id: <b70d5991caea5f3865cd31e1a117a017421a80a0.1295006565.git.mfm@muteddisk.com>
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
1.7.3.4

