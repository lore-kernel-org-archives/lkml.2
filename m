Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2CUJzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:55:05 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54937 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab2CUJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 05/11] m68k/atari: Add missing platform check before registering platform devices
Date: Wed, 21 Mar 2012 10:51:49 +0100
Message-Id: <1332323515-7314-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On multi-platform kernels, the Atari platform devices should be registered
when running on Atari only. Else it may crash later.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/config.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index af78731..35fb81d 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -693,6 +693,9 @@ static struct platform_device *atari_platform_devices[] __initdata = {
 
 int __init atari_platform_init(void)
 {
+	if (!MACH_IS_ATARI)
+		return -ENODEV;
+
 	return platform_add_devices(atari_platform_devices, ARRAY_SIZE(atari_platform_devices));
 }
 
-- 
1.7.0.4

