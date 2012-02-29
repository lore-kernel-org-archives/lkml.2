Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2B2I5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:57:00 -0500
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:50205 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750773Ab2B2I47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:56:59 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 03:56:58 EST
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mla@apm.com designates 10.68.197.35 as permitted sender) smtp.mail=mla@apm.com
MIME-Version: 1.0
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
Subject: [PATCH 2/2] powerpc/44x: Add PCI MSI node for APM821xx SoC and Bluestone board in DTS
Date: Wed, 29 Feb 2012 15:47:43 +0700
Message-Id: <1330505263-3718-1-git-send-email-mla@apm.com>
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

CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information 
that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.

