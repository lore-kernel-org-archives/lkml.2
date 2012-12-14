Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2LNKpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:45:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9217 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2LNKpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:45:10 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f3-50cb02e9de54
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH] gpio: samsung: add GPIO interrupt registration for exynos5
Date: Fri, 14 Dec 2012 19:44:02 +0900
Message-id: <1355481842-17952-2-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
References: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zPd2XTKcDDL70clhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX87lrCWHBIpGJ12xfmBsbpAl2MnBwSAiYSszYvYoGw
	xSQu3FvPBmILCSxjlOi9HA1T83rPH6A4F1B8OqPEtcm/mSCcFiaJczOa2EGq2AT0JO5sO84E
	YosImEtMef0KbBKzQLlE++/dzCC2sIC3xJFd/1m7GDk4WARUJc7t4wQxeQXcJVq/5oCYEgIK
	EnMm2YAUcwp4SFw42AZ1jrvE1b7pYMNZBAQkvk0+xAJRLiux6QAzyDESAtfZJBofbGaFOFlS
	4uCKGywTGIUXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgJQ+kdjKsaLA4xCnAwKvHw
	fhA6FSDEmlhWXJl7iFGCg1lJhFfyCFCINyWxsiq1KD++qDQntfgQow/QJROZpUST84ExklcS
	b2hsYGxoaGloZmppaoBDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDY2F+SfHEfzODg78t
	yuGt9Vp09MJtgbme839eb/A62KzsXrBo9qXCTFNO3/dRlns3SbMsNagr9nu8SGIN7+G0nbp5
	bpIvGx6nX3bNEOj8YRXufMKxa05thvbOVunfzh432JlLO6qii+23balgduR1Y38gd/mnW4wQ
	B2el1x3htAfrtM9ucp+lxFKckWioxVxUnAgAc26dN3ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoO5LptMBBldsLC7vmsNmMeP8PiYH
	Jo/Pm+QCGKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ0
	3TJzgCYrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDN+dy1hLDgkUrG6
	7QtzA+N0gS5GTg4JAROJ13v+sEHYYhIX7q0Hsrk4hASmM0pcm/ybCcJpYZI4N6OJHaSKTUBP
	4s6240wgtoiAucSU16/AupkFyiXaf+9mBrGFBbwljuz6z9rFyMHBIqAqcW4fJ4jJK+Au0fo1
	B8SUEFCQmDPJBqSYU8BD4sLBNrAhQkAVV/umM01g5F3AyLCKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzjIn0nvYFzVYHGIUYCDUYmH94PQqQAh1sSy4srcQ4wSHMxKIrySR4BCvCmJlVWp
	RfnxRaU5qcWHGH2ATprILCWanA+MwLySeENjEzMjSyMzYxNzY2McwkrivM0eKQFCAumJJanZ
	qakFqUUw45g4OKUaGHk7QzeGy8WtnVx6Wt8wZrbPAasdN1vkExOmNF1yXGfhfVIrVvDJlon+
	3cvOJ20L2j9n6u0J8rMZVr1veVISdGbjTutJE0zrehdYxsvNlGt0TLl967uG2IaS5l/rHFzz
	O00XRqz80lAtZGx6Kozn5+OLp+dWsUnPLOzddSQ/RkLZfm9o/o25LkosxRmJhlrMRcWJAKu9
	3SufAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds GPIO interrupt registration and modification needs to register
GPIO interrupt rightly for exynos5 SoCs. EXYNOS5_GPYx gpios shouldn't be
counted to GPIO interrupt group register number because they doesn't
support GPIO interrupt, so their struct samsung_gpio_cfg should be
initialized to &samsung_gpio_cfgs[8] in declaration ahead.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpio/gpio-samsung.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index e30cd60..a462f2c 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2519,42 +2519,49 @@ static struct samsung_gpio_chip exynos5_gpios_1[] = {
 			.label	= "GPD1",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY0(0),
 			.ngpio	= EXYNOS5_GPIO_Y0_NR,
 			.label	= "GPY0",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY1(0),
 			.ngpio	= EXYNOS5_GPIO_Y1_NR,
 			.label	= "GPY1",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY2(0),
 			.ngpio	= EXYNOS5_GPIO_Y2_NR,
 			.label	= "GPY2",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY3(0),
 			.ngpio	= EXYNOS5_GPIO_Y3_NR,
 			.label	= "GPY3",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY4(0),
 			.ngpio	= EXYNOS5_GPIO_Y4_NR,
 			.label	= "GPY4",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY5(0),
 			.ngpio	= EXYNOS5_GPIO_Y5_NR,
 			.label	= "GPY5",
 		},
 	}, {
+		.config	= &samsung_gpio_cfgs[8],
 		.chip	= {
 			.base	= EXYNOS5_GPY6(0),
 			.ngpio	= EXYNOS5_GPIO_Y6_NR,
@@ -3002,6 +3009,24 @@ static __init void exynos5_gpiolib_init(void)
 	}
 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_4,
 				       nr_chips, gpio_base4);
+
+#ifdef CONFIG_S5P_GPIO_INT
+	s5p_register_gpioint_bank(EXYNOS5_IRQ_GPIO_XA, 0,
+			EXYNOS5_IRQ_GPIO1_NR_GROUPS);
+	s5p_register_gpioint_bank(EXYNOS5_IRQ_GPIO_XB,
+			EXYNOS5_IRQ_GPIO1_NR_GROUPS,
+			EXYNOS5_IRQ_GPIO2_NR_GROUPS);
+	s5p_register_gpioint_bank(EXYNOS5_IRQ_GPIO_C2C,
+			EXYNOS5_IRQ_GPIO1_NR_GROUPS +
+			EXYNOS5_IRQ_GPIO2_NR_GROUPS,
+			EXYNOS5_IRQ_GPIO3_NR_GROUPS);
+	s5p_register_gpioint_bank(EXYNOS5_IRQ_GPIO,
+			EXYNOS5_IRQ_GPIO1_NR_GROUPS +
+			EXYNOS5_IRQ_GPIO2_NR_GROUPS +
+			EXYNOS5_IRQ_GPIO3_NR_GROUPS,
+			EXYNOS5_IRQ_GPIO4_NR_GROUPS);
+#endif
+
 	return;
 
 err_ioremap4:
-- 
1.7.9.5

