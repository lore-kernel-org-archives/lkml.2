Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279Ab2CUJxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:53:44 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:48890 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab2CUJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Subject: [PATCH 07/11] m68k/mac: Add missing platform check before registering platform devices
Date: Wed, 21 Mar 2012 10:51:51 +0100
Message-Id: <1332323515-7314-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On multi-platform kernels, the Mac platform devices should be registered
when running on Mac only. Else it may crash later.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org
---
 arch/m68k/mac/config.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index f60ff5f..da3b8d8 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -981,6 +981,9 @@ int __init mac_platform_init(void)
 {
 	u8 *swim_base;
 
+	if (!MACH_IS_MAC)
+		return -ENODEV;
+
 	/*
 	 * Serial devices
 	 */
-- 
1.7.0.4

