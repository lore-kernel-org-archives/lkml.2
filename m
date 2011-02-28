Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab1CATip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:38:45 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab1CAThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:25 -0500
Message-Id: <201103011934.p21JYesx010311@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 16:01:09 -0500
Subject: [PATCH] arch/tile: add some more VMSPLIT options and use consistent naming
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:40.0826 (UTC) FILETIME=[B56C91A0:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames 3G_OPT to 2_75G, and adds 2_5G and 2_25G.

For memory-intensive applications that are also network-buffer
intensive it can be helpful to be able to tune the virtual address
of the start of kernel memory.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 92f7ea0..eed0fc5 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -234,8 +234,12 @@ choice
 		bool "3.5G/0.5G user/kernel split"
 	config VMSPLIT_3G
 		bool "3G/1G user/kernel split"
-	config VMSPLIT_3G_OPT
-		bool "3G/1G user/kernel split (for full 1G low memory)"
+	config VMSPLIT_2_75G
+		bool "2.75G/1.25G user/kernel split (for full 1G low memory)"
+	config VMSPLIT_2_5G
+		bool "2.5G/1.5G user/kernel split"
+	config VMSPLIT_2_25G
+		bool "2.25G/1.75G user/kernel split"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
 	config VMSPLIT_1G
@@ -246,7 +250,9 @@ config PAGE_OFFSET
 	hex
 	default 0xF0000000 if VMSPLIT_3_75G
 	default 0xE0000000 if VMSPLIT_3_5G
-	default 0xB0000000 if VMSPLIT_3G_OPT
+	default 0xB0000000 if VMSPLIT_2_75G
+	default 0xA0000000 if VMSPLIT_2_5G
+	default 0x90000000 if VMSPLIT_2_25G
 	default 0x80000000 if VMSPLIT_2G
 	default 0x40000000 if VMSPLIT_1G
 	default 0xC0000000
-- 
1.6.5.2

