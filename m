Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1AaVE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:04:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56378 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab1AaVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:04:24 -0500
Subject: [PATCH v2 6/6] arm/dt: Basic tegra devicetree support
To: nicolas.pitre@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        buytenh@wantstofly.org, Olof Johansson <olof@lixom.net>,
        john.linn@xilinx.com, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 14:04:21 -0700
Message-ID: <20110131210421.15105.61900.stgit@localhost6.localdomain6>
In-Reply-To: <20110131203626.15105.64302.stgit@localhost6.localdomain6>
References: <20110131203626.15105.64302.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds adds very basic support for booting tegra with a
device tree.  It simply allows the existing machine_descs to match
against the tegra compatible values so that the kernel can boot.
Kernel parameters and the initrd pointer is read out of the tree
instead of atags.

This is not complete device tree support.  This change will be
reverted when a new machine_desc is added that can populate the
device registrations directly from data in the tree instead of using
hard coded data.  That change will be made in a future patch.

v2: Fixed cut-and-paste error in commit text

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-tegra/board-harmony.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index b9dbdb1..99884e9 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -113,6 +113,11 @@ static void __init tegra_harmony_init(void)
 	platform_add_devices(harmony_devices, ARRAY_SIZE(harmony_devices));
 }
 
+static const char * tegra_harmony_board_compat[] = {
+	"nvidia,harmony",
+	NULL
+};
+
 MACHINE_START(HARMONY, "harmony")
 	.boot_params  = 0x00000100,
 	.fixup		= tegra_harmony_fixup,
@@ -120,4 +125,5 @@ MACHINE_START(HARMONY, "harmony")
 	.init_machine   = tegra_harmony_init,
 	.map_io         = tegra_map_common_io,
 	.timer          = &tegra_timer,
+	.dt_compat      = tegra_harmony_board_compat,
 MACHINE_END

