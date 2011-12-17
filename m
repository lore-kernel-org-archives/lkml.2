Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1LQDzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 22:55:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60327 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1LQDzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 22:55:40 -0500
Message-ID: <1324094127.2554.0.camel@phoenix>
Subject: [PATCH] rtc: Staticise jz4740_rtc_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 17 Dec 2011 11:55:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jz4740_rtc_driver is not used outside this driver so no need to
make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-jz4740.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 1481e36..05ab227 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -345,7 +345,7 @@ static const struct dev_pm_ops jz4740_pm_ops = {
 #define JZ4740_RTC_PM_OPS NULL
 #endif  /* CONFIG_PM */
 
-struct platform_driver jz4740_rtc_driver = {
+static struct platform_driver jz4740_rtc_driver = {
 	.probe	 = jz4740_rtc_probe,
 	.remove	 = __devexit_p(jz4740_rtc_remove),
 	.driver	 = {
-- 
1.7.5.4



