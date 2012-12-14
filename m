Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2LNG6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:58:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29932 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2LNG6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:58:49 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c1-50cace2887cf
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: thierry.reding@avionic-design.de
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH v2] pwm: samsung: add missing s3c->pwm_id
Date: Fri, 14 Dec 2012 15:58:58 +0900
Message-id: <1355468338-12611-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zLV2Nc6cCDF7+5bC4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr42sBRcIO1YvWWfvYGxrMsXYycHBICJhLzjh1jhLDF
	JC7cW8/WxcjFISSwjFHi+JZlbDBFc7e/YYRILGKUuHtgAxOE08IkceN8CztIFZuAnsSdbceZ
	QGwRARWJaWsegNnMAuUS7b93M3cxcnAIC1hK/P1hBGKyCKhKfO0LBqngFXCXWHT2BCtIWEJA
	QWLOJBuQMIuAgMS3yYdYIMKyEpsOMIMslRA4wCax99J2ZojTJCUOrrjBMoFRcAEjwypG0dSC
	5ILipPRcQ73ixNzi0rx0veT83E2MkLCS2sG4ssHiEKMAB6MSD+9HoVMBQqyJZcWVuYcYJTiY
	lUR4JY8AhXhTEiurUovy44tKc1KLDzH6AF0ykVlKNDkfGPJ5JfGGxgbGhoaWhmamlqYGOISV
	xHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTCGrxHvO3jY+EGipVTqVB3n2/7zdm/8J2j3hqFF
	vCeMu36Lov8ir7Dv543aH62e06l2ttB+93K5bC3md8dSZiQsC/61Scfe1kt35WPvj1bRCbtz
	X7enK4XFfpwbOMfdylM/Iql0Nde56fHS77jM19X3pP64fvPX36svWZ9kqS93efe0x1u6J06J
	pTgj0VCLuag4EQA8tU87WAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAV2Nc6cCDG48YLa4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+NrAUXCDtWL1
	ln72BsazLF2MnBwSAiYSc7e/YYSwxSQu3FvP1sXIxSEksIhR4u6BDUwQTguTxI3zLewgVWwC
	ehJ3th1nArFFBFQkpq15AGYzC5RLtP/ezdzFyMEhLGAp8feHEYjJIqAq8bUvGKSCV8BdYtHZ
	E6wgYQkBBYk5k2wmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREctM+kdjCubLA4
	xCjAwajEw/tR6FSAEGtiWXFl7iFGCQ5mJRFeySNAId6UxMqq1KL8+KLSnNTiQ4w+QLsnMkuJ
	JucDIyqvJN7Q2MTMyNLIzNjE3NgYh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsaWDyuW
	/HXaKX/lnm+94dVfmkeDVe1qPeby7VmxlmP2DvdNz65v0tJUkr6zxPfznQ8T+1+fe5O6Yab3
	lEmiLKHfas66zdrGoJVx/uz3l1rKD7YyuHrNPCpWULvu8LenR2M2TL2q/eYkr76fUaRPSRD3
	Z9OU462xNwVWnmnTyOyKMjrz9Rp/pfQLJZbijERDLeai4kQA1BKfuocCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3c->pwm_id is used to calculate offset of related register.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
Changelog from v1:
 - move the assignment code to below.

 drivers/pwm/pwm-samsung.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 023a3be..0704a2a 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -222,6 +222,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 
 	/* calculate base of control bits in TCON */
 	s3c->tcon_base = id == 0 ? 0 : (id * 4) + 4;
+	s3c->pwm_id = id;
 	s3c->chip.dev = &pdev->dev;
 	s3c->chip.ops = &s3c_pwm_ops;
 	s3c->chip.base = -1;
-- 
1.7.9.5

