Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2JWFIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:08:43 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60799 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2JWFIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:08:42 -0400
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 13:08:41 +0800
Message-ID: <CAPgLHd-q7WCFrO_hW3nGHPj784jMtR9=fEzMqo5uQKapwO2NUA@mail.gmail.com>
Subject: [PATCH] rtc: avoid calling platform_device_put() twice in test_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.zummo@towertech.it
Cc: yongjun_wei@trendmicro.com.cn, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function test_init() need to call
platform_device_del() instead of platform_device_unregister().
Otherwise, we may call platform_device_put() twice.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/rtc/rtc-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 7e96254..209a127 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -164,7 +164,7 @@ static int __init test_init(void)
 	return 0;
 
 exit_device_unregister:
-	platform_device_unregister(test0);
+	platform_device_del(test0);
 
 exit_free_test1:
 	platform_device_put(test1);


