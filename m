Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1LVUUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:20:41 -0500
Received: from border.exmeritus.com ([70.167.241.26]:32959 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1LVUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:20:29 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] fsl/mpic: Document and use the "big-endian" device-tree flag
Date: Thu, 22 Dec 2011 15:19:10 -0500
Message-Id: <1324585155-13453-3-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MPIC code checks for a "big-endian" property and sets the flag
MPIC_BIG_ENDIAN if one is present, although prior to the "mpic->flags"
fixup that would never have worked anways.

Unfortunately, even now that it works properly, the Freescale mpic
device-node (the "PowerQUICC-III"-compatible one) does not specify it,
so all of the board ports need to manually pass it to mpic_alloc().

Document the flag and add it to the pq3 device tree.  Existing code will
still need to pass the MPIC_BIG_ENDIAN flag because their dtb may not
have this property, but new platforms shouldn't need to do so.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |    9 ++++++++-
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |    1 +
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
index 2cf38bd..ebafba2 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
@@ -56,7 +56,14 @@ PROPERTIES
           to the client.  The presence of this property also mandates
           that any initialization related to interrupt sources shall
           be limited to sources explicitly referenced in the device tree.
-       
+
+  - big-endian
+      Usage: optional
+      Value type: <empty>
+          If present the MPIC will be assumed to be big-endian.  Some
+          device-trees omit this property on MPIC nodes even when the MPIC is
+          in fact big-endian, so certain boards override this property.
+
 INTERRUPT SPECIFIER DEFINITION
 
   Interrupt specifiers consists of 4 cells encoded as
diff --git a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
index 5c80460..47f2b67 100644
--- a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
+++ b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
@@ -39,6 +39,7 @@ mpic: pic@40000 {
 	reg = <0x40000 0x40000>;
 	compatible = "fsl,mpic";
 	device_type = "open-pic";
+	big-endian;
 };
 
 timer@41100 {
-- 
1.7.7.3

