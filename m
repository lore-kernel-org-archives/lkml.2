Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2HGW2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:28:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58490 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab2HGW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:28:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [ 020/122] ARM: dt: tegra trimslice: add vbus-gpio property
Date: Tue,  7 Aug 2012 15:25:08 -0700
Message-Id: <20120807221950.048650407@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 01ad8063a5db9ac8320f197577a34b423ba64eca upstream.

On TrimSlice, Tegra's USB1 port may be routed to either an external micro
USB port, or an internal USB->SATA bridge for SSD or HDD. This muxing is
controlled by a GPIO. Whilst not strictly a VBUS GPIO, the TrimSlice
board files caused this GPIO to be set appropriately to enable the SATA
bridge by passing it as the VBUS GPIO to the USB driver. Echo this same
configuration in device tree to enable the SATA bridge.

An alternative might be to implement a full USB bus mux driver. However,
that seems over-complex right now.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra-trimslice.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/tegra-trimslice.dts
+++ b/arch/arm/boot/dts/tegra-trimslice.dts
@@ -276,6 +276,7 @@
 
 	usb@c5000000 {
 		status = "okay";
+		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
 	};
 
 	usb@c5004000 {


