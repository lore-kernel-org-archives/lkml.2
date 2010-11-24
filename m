Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0KXTFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:05:16 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:12905 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0KXTFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:05:15 -0500
Message-Id: <201011241905.oAOJ5Etn028906@farm-0013.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 24 Nov 2010 13:42:15 -0500
Subject: [PATCH] arch/tile: make glibc's sysconf(_SC_NPROCESSORS_CONF) work correctly
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 24 Nov 2010 19:05:14.0481 (UTC) FILETIME=[8687F610:01CB8C0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc assumes that it can count /sys/devices/system/cpu/cpu* to get
the number of configured cpus.  For this to be valid on tile, we need
to generate a "cpu" entry for all cpus, including the ones that are
not currently allocated for Linux's use.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index fb0b3cb..f185736 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -840,7 +840,7 @@ static int __init topology_init(void)
 	for_each_online_node(i)
 		register_one_node(i);
 
-	for_each_present_cpu(i)
+	for (i = 0; i < smp_height * smp_width; ++i)
 		register_cpu(&cpu_devices[i], i);
 
 	return 0;
-- 
1.6.5.2

