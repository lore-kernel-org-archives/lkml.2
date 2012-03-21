Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2CUJzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:55:02 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:34120 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2CUJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 04/11] m68k/amiga: Use arch_initcall() for registering platform devices
Date: Wed, 21 Mar 2012 10:51:48 +0100
Message-Id: <1332323515-7314-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_init() maps to device_initcall(), opening the possibility of
race conditions between platform_driver_probe() and registering platform
devices.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 2872891..80076d3 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -252,4 +252,4 @@ static int __init amiga_init_devices(void)
 	return 0;
 }
 
-device_initcall(amiga_init_devices);
+arch_initcall(amiga_init_devices);
-- 
1.7.0.4

