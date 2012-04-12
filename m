Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab2DLBYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:24:15 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:51230 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933490Ab2DLBYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:24:14 -0400
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>,
        Liu Guoli <liuguoli@mprc.pku.edu.cn>
Subject: [PATCH] UniCore32 bugfix: add missed CONFIG_ZONE_DMA
Date: Thu, 12 Apr 2012 09:28:53 +0800
Message-Id: <1334194133-9333-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because our PCI-bus handler confines dma zone into 128M, we should add
CONFIG_ZONE_DMA for all boards. Otherwise, all memory bigger than 128M
will be pushed into ZONE_MOVABLE.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Liu Guoli <liuguoli@mprc.pku.edu.cn>
Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..9f40a57 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -67,6 +67,9 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
+config ZONE_DMA
+	def_bool y
+
 config NEED_DMA_MAP_STATE
        def_bool y
 
-- 
1.7.0.4

