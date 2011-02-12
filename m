Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1BLIPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 03:15:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52155 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1BLIO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 03:14:57 -0500
Subject: [PATCH v3 5/6] arm/dt: Basic versatile devicetree support
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, john.linn@xilinx.com,
        buytenh@wantstofly.org
Date: Sat, 12 Feb 2011 01:14:53 -0700
Message-ID: <20110212081453.15682.41183.stgit@localhost6.localdomain6>
In-Reply-To: <20110212080634.15682.21141.stgit@localhost6.localdomain6>
References: <20110212080634.15682.21141.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds adds very basic support for booting versatile with a
device tree.  It simply allows the existing machine_descs to match
against the versatile ab & pb compatible values so that the kernel can
boot.  Kernel parameters and the initrd pointer is read out of the
tree instead of atags.

This is not complete device tree support.  This change will be
reverted when a new machine_desc is added that can populate the
versatile device registrations directly from data in the tree instead
of using hard coded data.  That change will be made in a future patch.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-versatile/versatile_ab.c |    6 ++++++
 arch/arm/mach-versatile/versatile_pb.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-versatile/versatile_ab.c b/arch/arm/mach-versatile/versatile_ab.c
index aa9730f..62053df 100644
--- a/arch/arm/mach-versatile/versatile_ab.c
+++ b/arch/arm/mach-versatile/versatile_ab.c
@@ -33,6 +33,11 @@
 
 #include "core.h"
 
+static const char *versatile_ab_match[] __initdata = {
+	"arm,versatile-ab",
+	NULL,
+};
+
 MACHINE_START(VERSATILE_AB, "ARM-Versatile AB")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.boot_params	= 0x00000100,
@@ -40,4 +45,5 @@ MACHINE_START(VERSATILE_AB, "ARM-Versatile AB")
 	.init_irq	= versatile_init_irq,
 	.timer		= &versatile_timer,
 	.init_machine	= versatile_init,
+	.dt_compat	= versatile_ab_match,
 MACHINE_END
diff --git a/arch/arm/mach-versatile/versatile_pb.c b/arch/arm/mach-versatile/versatile_pb.c
index bf46964..eba12fa 100644
--- a/arch/arm/mach-versatile/versatile_pb.c
+++ b/arch/arm/mach-versatile/versatile_pb.c
@@ -106,6 +106,11 @@ static void __init versatile_pb_init(void)
 	}
 }
 
+static const char *versatile_pb_match[] __initdata = {
+	"arm,versatile-pb",
+	NULL,
+};
+
 MACHINE_START(VERSATILE_PB, "ARM-Versatile PB")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.boot_params	= 0x00000100,
@@ -113,4 +118,5 @@ MACHINE_START(VERSATILE_PB, "ARM-Versatile PB")
 	.init_irq	= versatile_init_irq,
 	.timer		= &versatile_timer,
 	.init_machine	= versatile_pb_init,
+	.dt_compat	= versatile_pb_match,
 MACHINE_END

