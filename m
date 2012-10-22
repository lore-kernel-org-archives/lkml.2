Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2JVFWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:22:17 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40258 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2JVFWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:22:16 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 13:22:15 +0800
Message-ID: <CAPgLHd-Rpp8NA7Oap_uiQ=tNXBCc1g0Bbg1Uv3ALrbQKW=evsw@mail.gmail.com>
Subject: [PATCH] Staging: ced1401: fix missing unlock on error in FreeCircBlock()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handle path in function
FreeCircBlock().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/ced1401/ced_ioc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index c9492ed..5813aee 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -1508,7 +1508,7 @@ int FreeCircBlock(DEVICE_EXTENSION * pdx, TCIRCBLOCK __user * pCB)
 		iReturn = U14ERR_BADAREA;
 
 	if (copy_to_user(pCB, &cb, sizeof(cb)))
-		return -EFAULT;
+		iReturn = -EFAULT;
 
 	mutex_unlock(&pdx->io_mutex);
 	return iReturn;


