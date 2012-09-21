Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2IUGAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:00:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37112 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2IUGAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:00:05 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 14:00:04 +0800
Message-ID: <CAPgLHd_7eQvfTLfTyiWOQXnSjwXp9z9OazGnAj2hGsLb07NfAg@mail.gmail.com>
Subject: [PATCH] staging: tidspbridge: fix return value check in dsp_wdt_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: omar.ramirez@ti.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
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
 drivers/staging/tidspbridge/core/wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index 870f934..268aba2 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -61,9 +61,9 @@ int dsp_wdt_init(void)
 
 	dsp_wdt.fclk = clk_get(NULL, "wdt3_fck");
 
-	if (dsp_wdt.fclk) {
+	if (!IS_ERR(dsp_wdt.fclk)) {
 		dsp_wdt.iclk = clk_get(NULL, "wdt3_ick");
-		if (!dsp_wdt.iclk) {
+		if (IS_ERR(dsp_wdt.iclk)) {
 			clk_put(dsp_wdt.fclk);
 			dsp_wdt.fclk = NULL;
 			ret = -EFAULT;


