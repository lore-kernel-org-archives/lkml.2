Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab2C3VFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:05:22 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934771Ab2C3VFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:01 -0400
Message-Id: <201203302104.q2UL4spL006254@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 13:56:04 -0400
Subject: [PATCH] arch/tile/Kconfig: don't specify CONFIG_PAGE_OFFSET for 64-bit builds
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:54.0194 (UTC) FILETIME=[C1363920:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's fixed at half the VA space and there's no point in configuring it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 30393aa..96033e2 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -243,6 +243,7 @@ endchoice
 
 config PAGE_OFFSET
 	hex
+	depends on !64BIT
 	default 0xF0000000 if VMSPLIT_3_75G
 	default 0xE0000000 if VMSPLIT_3_5G
 	default 0xB0000000 if VMSPLIT_2_75G
-- 
1.6.5.2

