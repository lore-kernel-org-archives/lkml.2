Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1KCDTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:19:11 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:9769 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1KCDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:19:08 -0400
Message-Id: <201111030319.pA33J7dA005866@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 2 Nov 2011 22:33:07 -0400
Subject: [PATCH] arch/tile: add the <arch> headers to the set of installed kernel headers
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 03 Nov 2011 03:19:07.0311 (UTC) FILETIME=[58C33BF0:01CC99D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These headers are similar to the <asm> headers that describe kernel
APIs, but instead describe aspects of the actual hardware in an
OS- and application-independent manner.  We need to include them in
the set of installed headers so that userspace tools (including glibc)
can build purely from the provided kernel headers.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/Kbuild |   17 +++++++++++++++++
 arch/tile/include/asm/Kbuild  |    2 ++
 2 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/include/arch/Kbuild

diff --git a/arch/tile/include/arch/Kbuild b/arch/tile/include/arch/Kbuild
new file mode 100644
index 0000000..9c0ea24
--- /dev/null
+++ b/arch/tile/include/arch/Kbuild
@@ -0,0 +1,17 @@
+header-y += abi.h
+header-y += chip.h
+header-y += chip_tile64.h
+header-y += chip_tilegx.h
+header-y += chip_tilepro.h
+header-y += icache.h
+header-y += interrupts.h
+header-y += interrupts_32.h
+header-y += interrupts_64.h
+header-y += opcode.h
+header-y += opcode_tilegx.h
+header-y += opcode_tilepro.h
+header-y += sim.h
+header-y += sim_def.h
+header-y += spr_def.h
+header-y += spr_def_32.h
+header-y += spr_def_64.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index aec60dc..0bb4264 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -1,5 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
+header-y += ../arch/
+
 header-y += ucontext.h
 header-y += hardwall.h
 
-- 
1.6.5.2

