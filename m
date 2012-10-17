Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2JQFt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:49:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64280 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2JQFt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:49:57 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-cd-507e470327f6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Marek Vasut'" <marek.vasut@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] backlight: lms283gf05: use devm_gpio_request_one
Date: Wed, 17 Oct 2012 14:49:55 +0900
Message-id: <003801cdac2b$3c1012f0$b43038d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2sKzvcDEobMz/wRHC1ZYoUdInICQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV1m97oAg6aruhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjwJ3t7AXvOCpm37zB0sC4nL2LkZNDQsBE4u3RJUwQtpjEhXvr
	2boYuTiEBKYzSnQv74JyZjNJvLh8hRGkik1ATeLLl8Ng3SICERLNM2Yxg9jMAqUS21YfArOF
	BVwljn3vZAGxWQRUJdZuO8UGYvMK2EocmLSJEcIWlPgx+R4LRK+WxOZtTawQtrzE5jVvgeZw
	AF2kLvHory7EKj2JCUf2QK0Skdj34h3jBEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERyYz6R2MK5ssDjEKMDBqMTD+2F2bYAQa2JZcWXuIUYJDmYlEV7z
	RqAQb0piZVVqUX58UWlOavEhRmkOFiVx3maPlAAhgfTEktTs1NSC1CKYLBMHp1QD416/FRMD
	Z0VZrgw6xJ7Jv3Xnis0332x+0lce+TTopbKS0rZXR8RP6MTvvrr0x+XKZV77ThRmP5l7aE3d
	hc/u7+XOVX7OaMssObb8o5eP3uEJxT1X6jlr7l4TWG593rdx7x2NbV4JS9pW/8iVdOo+cdts
	xnLry15xryu/beKsdZf3fxv885u9jpISS3FGoqEWc1FxIgACNlbFSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using devm_gpio_request_one it is possible to set the direction
and initial value in one shot. Thus, using devm_gpio_request_one
can make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/video/backlight/lms283gf05.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index ea43f22..c452210 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -158,13 +158,9 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 	int ret = 0;
 
 	if (pdata != NULL) {
-		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
-					"LMS285GF05 RESET");
-		if (ret)
-			return ret;
-
-		ret = gpio_direction_output(pdata->reset_gpio,
-						!pdata->reset_inverted);
+		ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
+				GPIOF_DIR_OUT | !pdata->reset_inverted,
+				"LMS285GF05 RESET");
 		if (ret)
 			return ret;
 	}
-- 
1.7.1


