Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2ARL0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:26:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2ARL0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:26:49 -0500
Message-ID: <1326886003.2984.3.camel@phoenix>
Subject: [PATCH 2/2] watchdog: wafer5823wdt: Fix handling
 WDIOS_DISABLECARD/WDIOS_ENABLECARD options
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Justin Cormack <justin@street-vision.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Date: Wed, 18 Jan 2012 19:26:43 +0800
In-Reply-To: <1326885901.2984.1.camel@phoenix>
References: <1326885901.2984.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While receiving WDIOS_DISABLECARD option for WDIOC_SETOPTIONS command,
call wafwdt_stop() to disable watchdog.
Call wafwdt_start() while receiving WDIOS_ENABLECARD option.

Current code has reverse behavior.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/wafer5823wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 42e940c..c3c3188 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -152,12 +152,12 @@ static long wafwdt_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		if (options & WDIOS_DISABLECARD) {
-			wafwdt_start();
+			wafwdt_stop();
 			retval = 0;
 		}
 
 		if (options & WDIOS_ENABLECARD) {
-			wafwdt_stop();
+			wafwdt_start();
 			retval = 0;
 		}
 
-- 
1.7.5.4



