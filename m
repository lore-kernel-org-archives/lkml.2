Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab2HCGqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:46:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15961 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2HCGqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:46:42 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-71-501b73cd54ed
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 2/3] pwm: samsung: set the number of PWMs as 4
Date: Fri, 03 Aug 2012 15:46:37 +0900
Message-id: <001701cd7143$baa55f80$2ff01e80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1xQ7qRnr6E4hSKSQ66cazJTPtUKA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd2zxdIBBnfWiVlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8uzeTpeAOW8X2O28ZGxi3s3YxcnJICJhINN35zgRh
	i0lcuLeerYuRi0NIYDqjRMfBB6wQzi9GiS1/voJVsQmoSXz5cpgdxBYRMJdYsmgvM4jNLJAp
	cXDlDiCbg0NYwFGiuY0bJMwioCpx+eQTsFZeAVuJWzchFvMKCEr8mHyPBaJVS2L9zuNMELa8
	xOY1b8HGSAioSzz6qwuxSU/i5Y4bUOUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxggP0mdQOxpUNFocYBTgYlXh4A02lA4RYE8uKK3MPMUpw
	MCuJ8B7LBQrxpiRWVqUW5ccXleakFh9ilOZgURLnNfb+6i8kkJ5YkpqdmlqQWgSTZeLglGpg
	3CD93cCYuddZ+GTJg62OkyW3fDExKJzY1Tb3oGOmgKCv9Dw/Pvurwlwsdo9a17670zZDWvBl
	3KHeA/YFX5cqrleQzp7Nrf+uQvr2P8ldNRXvOE4VXPIy9V3ZsKh3yW/xzNSKFJn81/2uZlEG
	hlZnJ3pvyxe5nVa7wffw1CvrOH6a31SXt+9RYinOSDTUYi4qTgQACBPBr0wCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung SoC can provide 4 PWMs; thus, the number of PWMs should be
set as 4.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on SMDKV310 board
 drivers/pwm/pwm-samsung.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index e5187c0..aa0fe6b 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -26,6 +26,8 @@
 
 #include <plat/regs-timer.h>
 
+#define NUM_PWM 4
+
 struct s3c_chip {
 	struct platform_device	*pdev;
 
@@ -228,7 +230,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	s3c->chip.dev = &pdev->dev;
 	s3c->chip.ops = &s3c_pwm_ops;
 	s3c->chip.base = -1;
-	s3c->chip.npwm = 1;
+	s3c->chip.npwm = NUM_PWM;
 
 	s3c->clk = devm_clk_get(dev, "pwm-tin");
 	if (IS_ERR(s3c->clk)) {
-- 
1.7.1


