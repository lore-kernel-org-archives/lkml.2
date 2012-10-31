Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2JaGrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:47:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60265 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2JaGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:47:37 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-e4-5090c987786c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Guenter Roeck'" <guenter.roeck@ericsson.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH v2 1/2] thermal: exynos: Fix wrong bit to control tmu core
Date: Wed, 31 Oct 2012 15:47:35 +0900
Message-id: <00f501cdb733$9c1eed20$d45cc760$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QA04GwQ
Content-language: ko
x-cr-hashedpuzzle: D6h7 Emk4 FTut IjhG K6mb MVnA VhPr YZv/ aXUY gWAt rywk t4yu
 wD/0 0Er3 5iK8
 6wiN;5;YQBtAGkAdAAuAGsAYQBjAGgAaABhAHAAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZwB1AGUAbgB0AGUAcgAuAHIAbwBlAGMAawBAAGUAcgBpAGMAcwBzAG8AbgAuAGMAbwBtADsAagBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHMAYQBjAGgAaQBuAC4AawBhAG0AYQB0AEAAbABpAG4AYQByAG8ALgBvAHIAZwA=;Sosha1_v1;7;{A897F806-1D0D-4D09-895E-2E1011208623};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Wed,
 31 Oct 2012 06:47:25
 GMT;WwBQAEEAVABDAEgAIAB2ADIAIAAxAC8AMgBdACAAdABoAGUAcgBtAGEAbAA6ACAAZQB4AHkAbgBvAHMAOgAgAEYAaQB4ACAAdwByAG8AbgBnACAAYgBpAHQAIAB0AG8AIABjAG8AbgB0AHIAbwBsACAAdABtAHUAIABjAG8AcgBlAA==
x-cr-puzzleid: {A897F806-1D0D-4D09-895E-2E1011208623}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAd32kxMCDL6uUbe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZnxZ9Yyy4zVbR/vYmcwPjMtYuRg4OCQETidanyV2MnECmmMSF
	e+vZuhi5OIQEFjFKzPx6hhHCmcckMXf3LyaQKjYBXYlj67ewgtgiAtESfxr3MIMUMQv0M0rc
	e/OXCWSqkAC3xOrmIJAaTgEeiXV/OplBwsICXhL/+xlBwiwCqhIN75pYQGxeATuJX1cPs0PY
	ghI/Jt8DizMLaEms33mcCcKWl9i85i0zxM3qEo/+6kJcYCTRfvUCVImIxL4X7xghfmlhk1gz
	0wbCNpWYv/UR2wRGkVlINsxCsmEWkg2zkIxawMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM46J9J7WBc2WBxiFGAg1GJh9fwX3+AEGtiWXFl7iFGCQ5mJRHekhkTAoR4UxIrq1KL8uOL
	SnNSiw8xSnOwKInzNnukBAgJpCeWpGanphakFsFkmTg4pRoY133L+ymwJUf67ZZgqc9HfJaI
	lr9PWW4tvPt5143iSxMnte2/f/CK7YvSLclR0m/ul2Y9O/Ji8Xu+zTwLP5l2R/Bt3O4ltfxx
	RNo0s6fvl3E79Mqkpsz7tGif57Pgo/dN3ZktGqoj1qsyJ3JXH2c8s9OyLVK/2FFpsXhyhUPo
	Xaf7HoEp4vWsSizFGYmGWsxFxYkAFmoJFHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[0]bit is used to enable/disable tmu core. [1] bit is a reserved bit.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index fd03e85..6ce6667 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -53,8 +53,8 @@
 #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
 #define EXYNOS_TMU_GAIN_SHIFT          8
 #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
-#define EXYNOS_TMU_CORE_ON             3
-#define EXYNOS_TMU_CORE_OFF            2
+#define EXYNOS_TMU_CORE_ON             1
+#define EXYNOS_TMU_CORE_OFF            0
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50

 /* Exynos4210 specific registers */
--
1.7.4.1

