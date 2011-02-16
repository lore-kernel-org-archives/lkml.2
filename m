Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab1BPBBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:01:52 -0500
Received: from kroah.org ([198.145.64.141]:46005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253Ab1BPAup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:11 2011
Message-Id: <20110216002111.633544940@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timur Tabi <timur@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 126/176] powerpc/85xx: fix compatible properties of the P1022DS DMA nodes used for audio
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Timur Tabi <timur@freescale.com>

commit b2e0861e51f2961954330dcafe6d148ee3ab5cff upstream.

In order to prevent the fsl_dma driver from claiming the DMA channels that the
P1022DS audio driver needs, the compatible properties for those nodes must say
"fsl,ssi-dma-channel" instead of "fsl,eloplus-dma-channel".

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/boot/dts/p1022ds.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/boot/dts/p1022ds.dts
+++ b/arch/powerpc/boot/dts/p1022ds.dts
@@ -280,13 +280,13 @@
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


