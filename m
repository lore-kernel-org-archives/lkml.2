Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0LKGbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 01:31:42 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:56487 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0LKGbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 01:31:40 -0500
X-Auth-Info: SgMSkCT8nOHTrX82moLxda3vyvC5QpJjljIltrEJfpc=
From: Heiko Schocher <hs@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Heiko Schocher <hs@denx.de>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] powerpc, video: add SM501 support for charon board.
Date: Sat, 11 Dec 2010 07:31:36 +0100
Message-Id: <1292049096-1852-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.2.3
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
- based against 2.6.37-rc4

./scripts/checkpatch.pl 0003-powerpc-video-add-SM501-support-for-charon-board.patch
total: 0 errors, 0 warnings, 21 lines checked

0003-powerpc-video-add-SM501-support-for-charon-board.patch has no obvious style problems and is ready for submission.

- changes since v1:
  - no board specific defconfig file for mpc52xx based boards as suggested
    from Wolfram Sang

- changes since v2:
  add Ben Dooks, Vincent Sanders and Samuel Ortiz and lkml to cc, as
  suggested from Paul Mundt.

 arch/powerpc/boot/dts/charon.dts |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/charon.dts b/arch/powerpc/boot/dts/charon.dts
index 9776889..d9af022 100644
--- a/arch/powerpc/boot/dts/charon.dts
+++ b/arch/powerpc/boot/dts/charon.dts
@@ -186,6 +186,7 @@
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <	0 0 0xfc000000 0x02000000
+				1 0 0xe0000000 0x04000000 // CS1 range, SM501
 				3 0 0xe8000000 0x00080000>;
 
 		flash@0,0 {
@@ -197,6 +198,14 @@
 			#address-cells = <1>;
 		};
 
+		display@1,0 {
+			compatible = "smi,sm501";
+			reg = <1 0x00000000 0x00800000
+			       1 0x03e00000 0x00200000>;
+			mode = "640x480-32@60";
+			interrupts = <1 1 3>;
+		};
+
 		mram0@3,0 {
 			compatible = "mtd-ram";
 			reg = <3 0x00000 0x80000>;
-- 
1.7.2.3

