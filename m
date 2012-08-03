Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2HCGr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:47:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28669 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2HCGrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:47:22 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-9d-501b73f9b716
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 3/3] pwm: samsung: replace pwm_id with hwpwm memeber of
 pwm_device
Date: Fri, 03 Aug 2012 15:47:21 +0900
Message-id: <001801cd7143$d4dc0930$7e941b90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1xQ9TC9D244gKmSXGRGoohcPaiIA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd2fxdIBBq++ilhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXseHaMqeAhd8XX92fYGxjvcHYxcnJICJhI9C/ZxgJh
	i0lcuLeerYuRi0NIYBGjRN+M/8wQzi9GiQev3rCCVLEJqEl8+XKYHcQWETCXWLJoLzOIzSyQ
	KXFw5Q4wW1ggXGLb8mtANRwcLAKqEivnV4KEeQVsJdY9+sECYQtK/Jh8jwWiVUti/c7jTBC2
	vMTmNW+ZQVolBNQlHv3VhdikJ9Gw5gRUuYjEvhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgAH0mvYNxVYPFIUYBDkYlHl4jSekAIdbEsuLK3EOM
	EhzMSiK8x3KBQrwpiZVVqUX58UWlOanFhxilOViUxHlNvL/6CwmkJ5akZqemFqQWwWSZODil
	GhjTGwTtnRc+cuu+pXBldsIlrsSrCQ8WKXW9ncrf1/VJ5eHywIuKHgm5bBMZ762dOy/xU7+F
	xRPLqU0c4qHzzr908mqd+K5A6NGyP3zVOVc8CkyWVPwoOPrDRTB5vnmrZfKhZvE2zqVL90ou
	E1Q4M3XPihKrL2dz5dT9RM5NYZE2uatpJRqSfkmJpTgj0VCLuag4EQAryeDSTAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces pwm_id with hwpwm memeber of pwm_device.
The pwm_id of struct s3c_chip is unncessary, since hwpwm can
do same thing.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on SMDKV310 board
 drivers/pwm/pwm-samsung.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index aa0fe6b..8888841 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -39,7 +39,6 @@ struct s3c_chip {
 	unsigned int		 duty_ns;
 
 	unsigned char		 tcon_base;
-	unsigned char		 pwm_id;
 	struct pwm_chip		 chip;
 };
 
@@ -138,8 +137,8 @@ static int s3c_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* The TCMP and TCNT can be read without a lock, they're not
 	 * shared between the timers. */
 
-	tcmp = __raw_readl(S3C2410_TCMPB(s3c->pwm_id));
-	tcnt = __raw_readl(S3C2410_TCNTB(s3c->pwm_id));
+	tcmp = __raw_readl(S3C2410_TCMPB(pwm->hwpwm));
+	tcnt = __raw_readl(S3C2410_TCNTB(pwm->hwpwm));
 
 	period = NS_IN_HZ / period_ns;
 
@@ -182,8 +181,8 @@ static int s3c_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	local_irq_save(flags);
 
-	__raw_writel(tcmp, S3C2410_TCMPB(s3c->pwm_id));
-	__raw_writel(tcnt, S3C2410_TCNTB(s3c->pwm_id));
+	__raw_writel(tcmp, S3C2410_TCMPB(pwm->hwpwm));
+	__raw_writel(tcnt, S3C2410_TCNTB(pwm->hwpwm));
 
 	tcon = __raw_readl(S3C2410_TCON);
 	tcon |= pwm_tcon_manulupdate(s3c);
-- 
1.7.1


