Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1HSCEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 22:04:55 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61025 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1HSCEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 22:04:54 -0400
Subject: [PATCH] PM: pm_clock.h needs to include linux/notifier.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 10:04:46 +0800
Message-ID: <1313719486.20874.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error:

  CC      drivers/base/power/clock_ops.o
In file included from drivers/base/power/clock_ops.c:13:
include/linux/pm_clock.h:15: error: field 'nb' has incomplete type
drivers/base/power/clock_ops.c: In function 'pm_clk_notify':
drivers/base/power/clock_ops.c:437: warning: type defaults to 'int' in declaration of '__mptr'
drivers/base/power/clock_ops.c:437: warning: initialization from incompatible pointer type
make[3]: *** [drivers/base/power/clock_ops.o] Error 1
make[2]: *** [drivers/base/power] Error 2
make[1]: *** [drivers/base] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next next-20110818.
Axel

 include/linux/pm_clock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_clock.h b/include/linux/pm_clock.h
index f888013..8348866 100644
--- a/include/linux/pm_clock.h
+++ b/include/linux/pm_clock.h
@@ -10,6 +10,7 @@
 #define _LINUX_PM_CLOCK_H
 
 #include <linux/device.h>
+#include <linux/notifier.h>
 
 struct pm_clk_notifier_block {
 	struct notifier_block nb;
-- 
1.7.4.1



