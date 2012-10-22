Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2JVFHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:07:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63939 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2JVFHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:07:36 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 13:07:35 +0800
Message-ID: <CAPgLHd_WPkme5KfgKAANms6XcGEys494fBxnjSnZ8v6KwvGEqA@mail.gmail.com>
Subject: [PATCH] Staging: vt6655: fix missing unlock on error in vCommandTimer()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handle path in function
vCommandTimer.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/vt6655/wcmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 94bd1fc..6d0b87a 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -412,6 +412,7 @@ vCommandTimer (
 		if (!is_channel_valid(pMgmt->uScanChannel)) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d \n",pMgmt->uScanChannel);
                     s_bCommandComplete(pDevice);
+                    spin_unlock_irq(&pDevice->lock);
                     return;
                 }
 //printk("chester-pMgmt->uScanChannel=%d,pDevice->byMaxChannel=%d\n",pMgmt->uScanChannel,pDevice->byMaxChannel);


