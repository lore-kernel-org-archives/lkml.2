Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1K2Eyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:54:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39404 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1K2Eyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:54:36 -0500
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH] pm/next: Fix Build pm by ERR_PTR
Date: Tue, 29 Nov 2011 13:56:54 +0900
Message-Id: <1322542614-15856-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERR_PTR needs linux/err.h.
This add linux/err.h to linux/pm_domain.h.

-----
In file included from drivers/sh/pm_runtime.c:15:
include/linux/pm_domain.h: In function 'dev_to_genpd':
include/linux/pm_domain.h:145: error: implicit declaration of function 'ERR_PTR'
include/linux/pm_domain.h:145: warning: return makes pointer from integer without a cast
In file included from include/linux/sh_clk.h:10,
from drivers/sh/pm_runtime.c:19:
include/linux/err.h: At top level:
include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
include/linux/pm_domain.h:145: note: previous implicit declaration of 'ERR_PTR' was here
make[2]: *** [drivers/sh/pm_runtime.o] Error 1
make[1]: *** [drivers/sh] Error 2
-----

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 include/linux/pm_domain.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index cc1a245..919bee1 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -9,6 +9,7 @@
 #ifndef _LINUX_PM_DOMAIN_H
 #define _LINUX_PM_DOMAIN_H
 
+#include <linux/err.h>
 #include <linux/device.h>
 
 enum gpd_status {
-- 
1.7.7

