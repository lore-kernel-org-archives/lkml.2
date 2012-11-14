Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2KNQ7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:59:30 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51634 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2KNQ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:59:29 -0500
From: Gernot Vormayr <gvormayr@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Gernot Vormayr <gvormayr@gmail.com>
Subject: [PATCH 1/1] powerpc: dts: virtex440: add ethernet phy to virtex440-ml507
Date: Wed, 14 Nov 2012 17:59:09 +0100
Message-Id: <1352912349-15538-1-git-send-email-gvormayr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the marvel phy which is present on the ml507 board.
Without this ethtool causes kernel-oopses.

Tested on ml507 board.

Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
---
 arch/powerpc/boot/dts/virtex440-ml507.dts |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/boot/dts/virtex440-ml507.dts b/arch/powerpc/boot/dts/virtex440-ml507.dts
index 52d8c1a..fc7073b 100644
--- a/arch/powerpc/boot/dts/virtex440-ml507.dts
+++ b/arch/powerpc/boot/dts/virtex440-ml507.dts
@@ -272,6 +272,12 @@
 				xlnx,temac-type = <0>;
 				xlnx,txcsum = <1>;
 				xlnx,txfifo = <0x1000>;
+                                phy-handle = <&phy7>;
+                                clock-frequency = <100000000>;
+                                phy7: phy@7 {
+                                          compatible = "marvell,88e1111";
+                                          reg = <7>;
+                                } ;
 			} ;
 		} ;
 		IIC_EEPROM: i2c@81600000 {
-- 
1.7.9.5

