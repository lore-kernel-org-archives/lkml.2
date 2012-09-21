Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2IUHCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:02:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45397 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2IUHCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:02:14 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 15:02:13 +0800
Message-ID: <CAPgLHd_VjTEpYmxnE8h26=uGswQXzGYqLMpPfjhf33e9w-pqKw@mail.gmail.com>
Subject: [PATCH] c2port: fix return value check in duramar2150_c2port_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: paul.gortmaker@windriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function c2port_device_register() returns
ERR_PTR() not NULL pointer. The NULL test in the return value
check should be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/c2port/c2port-duramar2150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/c2port/c2port-duramar2150.c b/drivers/misc/c2port/c2port-duramar2150.c
index 5484301..3dc61ea 100644
--- a/drivers/misc/c2port/c2port-duramar2150.c
+++ b/drivers/misc/c2port/c2port-duramar2150.c
@@ -129,8 +129,8 @@ static int __init duramar2150_c2port_init(void)
 
 	duramar2150_c2port_dev = c2port_device_register("uc",
 					&duramar2150_c2port_ops, NULL);
-	if (!duramar2150_c2port_dev) {
-		ret = -ENODEV;
+	if (IS_ERR(duramar2150_c2port_dev)) {
+		ret = PTR_ERR(duramar2150_c2port_dev);
 		goto free_region;
 	}
 


