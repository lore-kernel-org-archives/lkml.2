Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1BCRjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:39:11 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13783 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab1BCRjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:39:10 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>
Subject: [PATCH] powerpc/85xx: fix compatible properties of the P1022DS DMA nodes used for audio
Date: Thu, 3 Feb 2011 11:39:04 -0600
Message-ID: <1296754744-22526-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent the fsl_dma driver from claiming the DMA channels that the
P1022DS audio driver needs, the compatible properties for those nodes must say
"fsl,ssi-dma-channel" instead of "fsl,eloplus-dma-channel".

Commit b2e0861e51f2961954330dcafe6d148ee3ab5cff upstream.

Signed-off-by: Timur Tabi <timur@freescale.com>
Cc: stable@kernel.org
---
 arch/powerpc/boot/dts/p1022ds.dts |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/dts/p1022ds.dts b/arch/powerpc/boot/dts/p1022ds.dts
index 2bbecbb..69422eb 100644
--- a/arch/powerpc/boot/dts/p1022ds.dts
+++ b/arch/powerpc/boot/dts/p1022ds.dts
@@ -291,13 +291,13 @@
 			ranges = <0x0 0xc100 0x200>;
 			cell-index = <1>;
 			dma00: dma-channel@0 {
-				compatible = "fsl,eloplus-dma-channel";
+				compatible = "fsl,ssi-dma-channel";
 				reg = <0x0 0x80>;
 				cell-index = <0>;
 				interrupts = <76 2>;
 			};
 			dma01: dma-channel@80 {
-				compatible = "fsl,eloplus-dma-channel";
+				compatible = "fsl,ssi-dma-channel";
 				reg = <0x80 0x80>;
 				cell-index = <1>;
 				interrupts = <77 2>;
-- 
1.7.3.4


