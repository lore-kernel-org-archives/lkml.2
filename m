Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1IZS1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:27:30 -0400
Received: from claw.goop.org ([74.207.240.146]:32963 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab1IZS13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:27:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <xen-devel@lists.xensource.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/3] xen: add dom0_op hypercall
Date: Mon, 26 Sep 2011 11:27:24 -0700
Message-Id: <eec07a9ecf428a680d72dc7f2428ea8bed80b84d.1317061152.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/hypercall.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index d240ea9..0c9894e 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -45,6 +45,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
+#include <xen/interface/platform.h>
 
 /*
  * The hypercall asms have to meet several constraints:
@@ -299,6 +300,13 @@ HYPERVISOR_set_timer_op(u64 timeout)
 }
 
 static inline int
+HYPERVISOR_dom0_op(struct xen_platform_op *platform_op)
+{
+	platform_op->interface_version = XENPF_INTERFACE_VERSION;
+	return _hypercall1(int, dom0_op, platform_op);
+}
+
+static inline int
 HYPERVISOR_set_debugreg(int reg, unsigned long value)
 {
 	return _hypercall2(int, set_debugreg, reg, value);
-- 
1.7.6.2

