Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2JWFd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:33:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40646 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab2JWFdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:33:25 -0400
X-AuditID: cbfee61b-b7f616d00000319b-21-50862c239cf9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: s6e63m0: remove unnecessary cast of void pointer
Date: Tue, 23 Oct 2012 14:33:23 +0900
Message-id: <000e01cdb0df$eb525710$c1f70530$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w3+sjLLskcJQkR+yws6C2uc6guw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQV1lnbYAg/ndehaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjyemlLAVb2CquLj3O1MC4kbWLkZNDQsBE4trV4ywQtpjEhXvr
	2boYuTiEBKYzSkxbu4MJwpnNJHHo5gN2kCo2ATWJL18Og9kiAhESzTNmMXcxcnAwC/hIbJ6l
	CRIWBjKnnnjNBGKzCKhKrJz2EGwZr4CtRPe0jVC2oMSPyffAFjMLaEms33mcCcKWl9i85i3Y
	SAkBdYlHf3UhNulJrJl9mh2iRERi34t3jBMYBWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwWD6T3sG4qsHiEKMAB6MSD2/H/tYAIdbEsuLK3EOMEhzMSiK8
	ygFAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp2ampBalFMFkmDk6pBkbD/9bn
	7+iuKKjc+3mv7tyWO8Ffn502u3XaZf7GW/vnLzyaEy8S+3f1keC/TR52k7KXPLG9rSrwtmAj
	l83766tmrjTO9lBzq7V9ESkXvcqeb0XBun+rttxjPfl5W8CEpz7qGiyWeitqm+qS8hLYnzZo
	9ez7Z+j941Hk9E1N03dfqV6u83HLih9VSizFGYmGWsxFxYkA/rBO5EcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unnecessary case of void pointer for platform data
in probe function.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/s6e63m0.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 6437ae4..1f435e2 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -757,7 +757,7 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = (struct lcd_platform_data *)spi->dev.platform_data;
+	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
 		return -EFAULT;
-- 
1.7.1


