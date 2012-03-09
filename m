Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2CIDTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:19:11 -0500
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:57224 "HELO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752365Ab2CIDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:19:09 -0500
From: Mai La <mla@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: open-source-review@apm.com, Mai La <mla@apm.com>
Subject: [PATCH 2/2] powerpc/44x: Add PCI MSI node for Maui APM821xx SoC and Bluestone board in DTS
Date: Fri,  9 Mar 2012 10:18:45 +0700
Message-Id: <1331263125-9647-1-git-send-email-mla@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mai La <mla@apm.com>
---
 arch/powerpc/boot/dts/bluestone.dts |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
index 2a56a0d..8ea6325 100644
--- a/arch/powerpc/boot/dts/bluestone.dts
+++ b/arch/powerpc/boot/dts/bluestone.dts
@@ -250,5 +250,29 @@
 			};
 		};
 
+		MSI: ppc4xx-msi@C10000000 {
+			compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
+			reg = < 0xC 0x10000000 0x100
+				0xC 0x10000000 0x100>;
+			sdr-base = <0x36C>;
+			msi-data = <0x00004440>;
+			msi-mask = <0x0000ffe0>;
+			interrupts =<0 1 2 3 4 5 6 7>;
+			interrupt-parent = <&MSI>;
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			msi-available-ranges = <0x0 0x100>;
+			interrupt-map = <
+				0 &UIC3 0x18 1
+				1 &UIC3 0x19 1
+				2 &UIC3 0x1A 1
+				3 &UIC3 0x1B 1
+				4 &UIC3 0x1C 1
+				5 &UIC3 0x1D 1
+				6 &UIC3 0x1E 1
+				7 &UIC3 0x1F 1
+			>;
+		};
 	};
 };
-- 
1.7.3.4

