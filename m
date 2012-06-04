Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2FDCRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:17:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11867 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2FDCRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:17:10 -0400
X-AuditID: cbfee61a-b7f996d000000ec4-f1-4fcc1aa59802
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@stericsson.com>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: samsung: fix build error for EXYNOS5250
Date: Mon, 04 Jun 2012 11:17:09 +0900
Message-id: <000101cd41f8$251e4cd0$6f5ae670$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1B+CTW1H/KAdVqSQaMQW142/IXiA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd2lUmf8DWZs0bC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZuyfsZim4w1FxbN1dlgbGdexdjJwcEgImEsd3XGOBsMUkLtxb
	z9bFyMUhJDCdUeLGvkNMEM5sJokTs++DdbAJqEl8+XIYyObgEBFIkHiysQokzCxQK/HvxwRG
	EFtYwE7i6/ZHYENZBFQlpl19wgxi8wrYSsx7epIJwhaU+DH5HgtEr5bE+p3HmSBseYnNa94y
	g4yXEFCXePRXFyQsIqAn0d71mR2iRERi34t3jBMYBWYhmTQLyaRZSCbNQtKygJFlFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwWD6T2sG4ssHiEKMAB6MSD6/Eq9P+QqyJZcWVuYcYJTiY
	lUR4GS4BhXhTEiurUovy44tKc1KLDzFKc7AoifPaLd7hLySQnliSmp2aWpBaBJNl4uCUamA8
	bH71+SzhL3/LvA64GyUKyr0xqTvveJNd49bVzLNuPwI3/3vLtZJp/cH9t3SEjps83rX/0/b9
	0wwevtyyQ71F9tXmx2KaLOt5hLX9+1/tXrjAKLzMcdKUxpPHdrxovblkcnC9n+OvOwftNJon
	5B559Ehvotm8lj1b/+Zdmvll0tx/n9WbXX5dUlJiKc5INNRiLipOBADKXFO/RwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo from "exonys5_gpios_1" to "exonys5_gpios_1"
in order to fix build error as below:

drivers/gpio/gpio-samsung.c: In function 'exynos5_gpiolib_init':
drivers/gpio/gpio-samsung.c:2836: error: 'exonys5_gpios_1' undeclared (first use in this function)
drivers/gpio/gpio-samsung.c:2836: error: (Each undeclared identifier is reported only once
drivers/gpio/gpio-samsung.c:2836: error: for each function it appears in.)

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 7bb0044..b6453d0 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2833,7 +2833,7 @@ static __init void exynos5_gpiolib_init(void)
 	}
 
 	/* need to set base address for gpc4 */
-	exonys5_gpios_1[11].base = gpio_base1 + 0x2E0;
+	exynos5_gpios_1[11].base = gpio_base1 + 0x2E0;
 
 	/* need to set base address for gpx */
 	chip = &exynos5_gpios_1[21];
-- 
1.7.1


