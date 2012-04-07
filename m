Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2DGXUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 19:20:09 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:5601 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2DGXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 19:20:06 -0400
Message-Id: <201204072319.q37NJisM019383@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 7 Apr 2012 15:58:24 -0400
Subject: [PATCH 2/3] arch/tile: mark TILEGX as not EXPERIMENTAL
In-Reply-To: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 07 Apr 2012 23:19:44.0829 (UTC) FILETIME=[EAE926D0:01CD1514]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also create a TILEPRO config setting to use for #ifdefs where it
is cleaner to do so, and make the 64BIT setting depend directly
on the setting of TILEGX.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 533820c..d51b479 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -113,16 +113,14 @@ config HVC_TILE
 	select HVC_DRIVER
 	def_bool y
 
-# Please note: TILE-Gx support is not yet finalized; this is
-# the preliminary support.  TILE-Gx drivers are only provided
-# with the alpha or beta test versions for Tilera customers.
 config TILEGX
-	depends on EXPERIMENTAL
 	bool "Building with TILE-Gx (64-bit) compiler and toolchain"
 
+config TILEPRO
+	def_bool !TILEGX
+
 config 64BIT
-	depends on TILEGX
-	def_bool y
+	def_bool TILEGX
 
 config ARCH_DEFCONFIG
 	string
-- 
1.6.5.2

