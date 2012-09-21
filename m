Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2IUHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:16:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43801 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2IUHQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:16:56 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 15:16:55 +0800
Message-ID: <CAPgLHd9i5kYKk+eTcC2ddu3k_F+PwdnVi91k4vEoj_wWkgBXDw@mail.gmail.com>
Subject: [PATCH] spi: sh-hspi: fix return value check in hspi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_get() returns ERR_PTR()
and never returns NULL pointer. The NULL test in the error
handling should be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-sh-hspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-hspi.c b/drivers/spi/spi-sh-hspi.c
index 934138c..ecb99f3 100644
--- a/drivers/spi/spi-sh-hspi.c
+++ b/drivers/spi/spi-sh-hspi.c
@@ -251,7 +251,7 @@ static int __devinit hspi_probe(struct platform_device *pdev)
 	}
 
 	clk = clk_get(NULL, "shyway_clk");
-	if (!clk) {
+	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "shyway_clk is required\n");
 		ret = -EINVAL;
 		goto error0;


