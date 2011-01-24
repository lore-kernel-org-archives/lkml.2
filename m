Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1AXJ5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:57:52 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:55009 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1AXJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:57:50 -0500
X-Auth-Info: w6U2/bs+wXUHr9q9tuRVQNUDj3cCkZFF37YdgH/SG84=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4 v4] powerpc, video: add SM501 support for charon board.
Date: Mon, 24 Jan 2011 10:57:48 +0100
Message-Id: <1295863068-11205-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1291451028-22532-2-git-send-email-hs@denx.de>
References: <1291451028-22532-2-git-send-email-hs@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Heiko Schocher <hs@denx.de>
cc: linux-fbdev@vger.kernel.org
cc: devicetree-discuss@ozlabs.org
cc: Ben Dooks <ben@simtec.co.uk>
cc: Vincent Sanders <vince@simtec.co.uk>
cc: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org

---
- changes since v1:
  - no board specific defconfig file for mpc52xx based boards as suggested
    from Wolfram Sang

- changes since v2:
  add Ben Dooks, Vincent Sanders and Samuel Ortiz and lkml to cc, as
  suggested from Paul Mundt.

- changes since v3:
  - rebased against v2.6.38-rc2

./scripts/checkpatch.pl 0004-powerpc-video-add-SM501-support-for-charon-board.patch
total: 0 errors, 0 warnings, 22 lines checked

0004-powerpc-video-add-SM501-support-for-charon-board.patch has no obvious style problems and is ready for submission.

 arch/powerpc/boot/dts/charon.dts |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/charon.dts b/arch/powerpc/boot/dts/charon.dts
index 9776889..0e00e50 100644
--- a/arch/powerpc/boot/dts/charon.dts
+++ b/arch/powerpc/boot/dts/charon.dts
@@ -186,6 +186,7 @@
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <	0 0 0xfc000000 0x02000000
+				1 0 0xe0000000 0x04000000 // CS1 range, SM501
 				3 0 0xe8000000 0x00080000>;
 
 		flash@0,0 {
@@ -197,6 +198,15 @@
 			#address-cells = <1>;
 		};
 
+		display@1,0 {
+			compatible = "smi,sm501";
+			reg = <1 0x00000000 0x00800000
+			       1 0x03e00000 0x00200000>;
+			mode = "640x480-32@60";
+			interrupts = <1 1 3>;
+			little-endian;
+		};
+
 		mram0@3,0 {
 			compatible = "mtd-ram";
 			reg = <3 0x00000 0x80000>;
-- 
1.7.3.4

