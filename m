Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DGMNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:13:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:37528 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab1DGMNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:13:16 -0400
Date: Thu, 7 Apr 2011 14:13:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de
Subject: [PATCH] x86/ce4100: add reg property to bridges
Message-ID: <20110407121315.GA9204@linutronix.de>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
 <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

without the reg property Ben's new code won't find the PCI & ISA bridge
and the devices won't get the DT-node attached.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

This patch can be applied independently of Ben's series but without it
we have almost no devices :).

 arch/x86/platform/ce4100/falconfalls.dts |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
index dc701ea..2d6d226 100644
--- a/arch/x86/platform/ce4100/falconfalls.dts
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -74,6 +74,7 @@
 				compatible = "intel,ce4100-pci", "pci";
 				device_type = "pci";
 				bus-range = <1 1>;
+				reg = <0x0800 0x0 0x0 0x0 0x0>;
 				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
 
 				interrupt-parent = <&ioapic2>;
@@ -412,6 +413,7 @@
 				#address-cells = <2>;
 				#size-cells = <1>;
 				compatible = "isa";
+				reg = <0xf800 0x0 0x0 0x0 0x0>;
 				ranges = <1 0 0 0 0 0x100>;
 
 				rtc@70 {
-- 
1.7.4

