Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2JHAns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:43:48 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61576 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2JHAnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:43:46 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 08:43:45 +0800
Message-ID: <CAPgLHd8d0v6fjMGJnK2LbRWTyhRh4DQXXNyxWo10=0Y+GVk7FA@mail.gmail.com>
Subject: [PATCH] staging: r8712u: fix potential NULL pointer dereference in r871x_wps_start()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index c9a6a7f..3a64790 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -2110,10 +2110,10 @@ static int r871x_wps_start(struct net_device *dev,
 	struct iw_point *pdata = &wrqu->data;
 	u32   u32wps_start = 0;
 
-	if (copy_from_user((void *)&u32wps_start, pdata->pointer, 4))
-		return -EFAULT;
 	if ((padapter->bDriverStopped) || (pdata == NULL))
 		return -EINVAL;
+	if (copy_from_user((void *)&u32wps_start, pdata->pointer, 4))
+		return -EFAULT;
 	if (u32wps_start == 0)
 		u32wps_start = *extra;
 	if (u32wps_start == 1) /* WPS Start */

