Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1JYQfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:35:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55695 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1JYQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:35:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6509"; a="130749516"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2] msm: boards: Fix fallout from removal of machine_desc in fixup
Date: Tue, 25 Oct 2011 09:35:19 -0700
Message-Id: <1319560519-18899-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.1.431.g10b2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 0744a3ee (ARM: platform fixups: remove mdesc argument to
fixup function, 2010-12-20) the fixup functions introduced in
9e775ad (ARM: 7012/1: Set proper TEXT_OFFSET for newer MSMs,
2011-08-12) cause warnings like:

arch/arm/mach-msm/board-msm8x60.c:85: warning: initialization
from incompatible pointer type

Fix them by removing the machine_desc argument from the fixup
functions.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I sent this a few weeks back. Looks like it was dropped though and
now the merge window is open and Linus' tree fails to boot on these
boards.

 arch/arm/mach-msm/board-msm7x30.c |    4 ++--
 arch/arm/mach-msm/board-msm8960.c |    4 ++--
 arch/arm/mach-msm/board-msm8x60.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index d1e4cc8..7a0af9f 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -43,8 +43,8 @@
 
 extern struct sys_timer msm_timer;
 
-static void __init msm7x30_fixup(struct machine_desc *desc, struct tag *tag,
-			 char **cmdline, struct meminfo *mi)
+static void __init msm7x30_fixup(struct tag *tag, char **cmdline,
+		struct meminfo *mi)
 {
 	for (; tag->hdr.size; tag = tag_next(tag))
 		if (tag->hdr.tag == ATAG_MEM && tag->u.mem.start == 0x200000) {
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index b04468e..6dc1cbd 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -32,8 +32,8 @@
 
 #include "devices.h"
 
-static void __init msm8960_fixup(struct machine_desc *desc, struct tag *tag,
-			 char **cmdline, struct meminfo *mi)
+static void __init msm8960_fixup(struct tag *tag, char **cmdline,
+		struct meminfo *mi)
 {
 	for (; tag->hdr.size; tag = tag_next(tag))
 		if (tag->hdr.tag == ATAG_MEM &&
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 9221f54..056d9d7 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -30,8 +30,8 @@
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
-static void __init msm8x60_fixup(struct machine_desc *desc, struct tag *tag,
-			 char **cmdline, struct meminfo *mi)
+static void __init msm8x60_fixup(struct tag *tag, char **cmdline,
+		struct meminfo *mi)
 {
 	for (; tag->hdr.size; tag = tag_next(tag))
 		if (tag->hdr.tag == ATAG_MEM &&
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

