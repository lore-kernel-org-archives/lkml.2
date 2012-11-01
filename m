Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478Ab2KANuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:50:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55404 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235Ab2KANuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:50:08 -0400
Message-ID: <50927DF5.4080008@ti.com>
Date: Thu, 1 Nov 2012 14:49:41 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: <tony@atomide.com>, <anilkumar@ti.com>, <rob.herring@calxeda.com>,
        <hvaibhav@ti.com>, <afzal@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v3] ARM: dts: AM33xx: Add SPI node
References: <1351680669-20718-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1351680669-20718-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avinash,

On 10/31/2012 11:51 AM, Philip, Avinash wrote:
> Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> as the driver) is reused from OMAP4.
> 
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Tested-by: Matt Porter <mporter@ti.com>

I've just realized the interrupt-parent was still there, so I removed both.

Please find below the updated version.

Regards,
Benoit

----
>From 9fd3c748aac9418cd377249ca463050783d2198f Mon Sep 17 00:00:00 2001
From: Philip, Avinash <avinashphilip@ti.com>
Date: Wed, 31 Oct 2012 16:21:09 +0530
Subject: [PATCH] ARM: dts: AM33XX: Add SPI node

Add McSPI data node to AM33XX device tree file. The McSPI module (and so
as the driver) is reused from OMAP4.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Tested-by: Matt Porter <mporter@ti.com>
[b-cousson@ti.com: Remove interrupt-parent]
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 97a7bd3..5dfd682 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -299,5 +299,27 @@
 				      76>;
 			ti,hwmods = "rtc";
 		};
+
+		spi0: spi@48030000 {
+			compatible = "ti,omap4-mcspi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x48030000 0x400>;
+			interrupt = <65>;
+			ti,spi-num-cs = <2>;
+			ti,hwmods = "spi0";
+			status = "disabled";
+		};
+
+		spi1: spi@481a0000 {
+			compatible = "ti,omap4-mcspi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x481a0000 0x400>;
+			interrupt = <125>;
+			ti,spi-num-cs = <2>;
+			ti,hwmods = "spi1";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.0.4


