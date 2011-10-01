Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab1JAUJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:09:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab1JAUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/26] ARM: pxa: mbxfb: disable broken debugfs code
Date: Sat,  1 Oct 2011 22:03:39 +0200
Message-Id: <1317499438-14058-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:mDfuIsg9kbAM/mOmk4JbEUFG/En33L4F49cD/wyRevA
 16RgS7Rr7ltSXSbGzjNMZfMCCoSt9RcvLo+L35gUOxCAJRw+BI
 hN7vhyrFgM6ScSA1xKqvlej+X/M6+xdZBfXYUaZ3+HR2DHz5Wk
 gVWvXGRbr3GVygsKRMz/UIRa1CYLGgwgwa+Y9XYjyJPx/8o9nd
 IBe65HVHJpxgPgl8d3quNfnUpPcm04zAMy5ifUn6E1jXbPV/77
 MctdtJQT6QLN7hS6y6Lkth6c+brJkzW47WbY/WWTNU+RHxaFvm
 etpiVzJmUDOeCJzCH9vbWgKWNlHQjA4OK4a6vVkencn5tKVwiQ
 I+lhpDW8Sc7xGek+B2i8E2KopGwiYH0NeGeBzhoFvDCbkDbFCS
 DoYT0tD0qO+aA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code has not worked for a long time, and even the
Makefile entry for building the file was misspelled.
Mark it as broken.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/Kconfig      |    2 +-
 drivers/video/mbx/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 549b960..45494c0 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1932,7 +1932,7 @@ config FB_MBX
 
 config FB_MBX_DEBUG
        bool "Enable debugging info via debugfs"
-       depends on FB_MBX && DEBUG_FS
+       depends on FB_MBX && DEBUG_FS && BROKEN
        default n
        ---help---
          Enable this if you want debugging information using the debug
diff --git a/drivers/video/mbx/Makefile b/drivers/video/mbx/Makefile
index 16c1165..a315abc 100644
--- a/drivers/video/mbx/Makefile
+++ b/drivers/video/mbx/Makefile
@@ -1,4 +1,4 @@
 # Makefile for the 2700G controller driver.
 
 obj-$(CONFIG_FB_MBX)	   += mbxfb.o
-obj-$(CONFIG_FB_MBX_DEBUG) += mbxfbdebugfs.o
+obj-$(CONFIG_FB_MBX_DEBUG) += mbxdebugfs.o
-- 
1.7.5.4

