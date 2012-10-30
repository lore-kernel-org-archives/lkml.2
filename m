Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2J3Fa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:30:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8329 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2J3Fa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:30:56 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-b7-508f660fc52c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Guenter Roeck'" <guenter.roeck@ericsson.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH 1/2] thermal: exynos: Fix wrong bit to control tmu core
Date: Tue, 30 Oct 2012 14:30:54 +0900
Message-id: <000001cdb65f$bbb93d40$332bb7c0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3Q==
Content-language: ko
x-cr-hashedpuzzle: Ahls AvG4 CUBt HBuj J0N/ M+c2 ZMVg bKBM cfV7 ekFm fM0G fbG8
 lY6k qni6 tT4Q
 umX5;4;YQBtAGkAdAAuAGsAYQBjAGgAaABhAHAAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZwB1AGUAbgB0AGUAcgAuAHIAbwBlAGMAawBAAGUAcgBpAGMAcwBzAG8AbgAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHMAYQBjAGgAaQBuAC4AawBhAG0AYQB0AEAAbABpAG4AYQByAG8ALgBvAHIAZwA=;Sosha1_v1;7;{02AAD814-2906-4C0B-8F17-43E393DC0B44};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Tue,
 30 Oct 2012 05:30:46
 GMT;WwBQAEEAVABDAEgAIAAxAC8AMgBdACAAdABoAGUAcgBtAGEAbAA6ACAAZQB4AHkAbgBvAHMAOgAgAEYAaQB4ACAAdwByAG8AbgBnACAAYgBpAHQAIAB0AG8AIABjAG8AbgB0AHIAbwBsACAAdABtAHUAIABjAG8AcgBlAA==
x-cr-puzzleid: {02AAD814-2906-4C0B-8F17-43E393DC0B44}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV3+tP4AgwubFS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGp0XfGAtus1W0v73J3MC4jLWLkYNDQsBE4vxx8S5GTiBTTOLC
	vfVsXYxcHEIC0xkljq6ewQrhzGOS2LD+FzNIFZuArsSx9VvAmkUE9CROnogHqWEW6GeUuPfm
	LxNIjbCAu8S7iZdYQWwWAVWJ91N2s4PYvAJ2Eo+2nWKFsAUlfky+xwJiMwtoSazfeZwJwpaX
	2LzmLTPEceoSj/7qgoRBVv1d1ARVIiKx78U7RpC9EgJ7WCWWPTjNDvGBqcS0ReeYJzAKzUKy
	YhaSFbOQrJiFZNYCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGB/ExqB+PKBotDjAIc
	jEo8vBvW9AUIsSaWFVfmHmKU4GBWEuHN9+4PEOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JES
	ICSQnliSmp2aWpBaBJNl4uCUamA0qfkun/Oujz98qsRae53II192/69hFmJVMlgd2zx1cvb9
	D5W+9vYsf19ejtxmt+PKgYlFCvcdHEKlGALmMm974PFP/3SzOKfM6e3ufgJKgbP6b7V8OOWo
	EnQ4uLHgK19Ou+X1Ey3ujVIzl+R+5b96P+ztRIOakEb+5jXpApc5Y0/0ZAhzKSuxFGckGmox
	FxUnAgDeaMboYAIAAA==
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

