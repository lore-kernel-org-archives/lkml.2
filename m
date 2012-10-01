Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab2JASsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:48:35 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21985 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2JASsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:48:33 -0400
Message-ID: <1349117311.2688.9.camel@lorien2>
Subject: [PATCH] dma-debug: Remove local BUS_NOTIFY_UNBOUND_DRIVER define
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Mon, 01 Oct 2012 12:48:31 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove local BUS_NOTIFY_UNBOUND_DRIVER define. This is not used since
BUS_NOTIFY_UNBOUND_DRIVER is defined in include/linux/device.h

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 lib/dma-debug.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 66ce414..b9087bf 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -120,11 +120,6 @@ static const char *type2name[4] = { "single", "page",
 static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
 				   "DMA_FROM_DEVICE", "DMA_NONE" };
 
-/* little merge helper - remove it after the merge window */
-#ifndef BUS_NOTIFY_UNBOUND_DRIVER
-#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
-#endif
-
 /*
  * The access to some variables in this macro is racy. We can't use atomic_t
  * here because all these variables are exported to debugfs. Some of them even
-- 
1.7.9.5




