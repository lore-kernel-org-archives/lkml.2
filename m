Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2JaGrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:47:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36324 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab2JaGr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:47:29 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-c1-5090c9805c80
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH v2 2/2] therma: exynos: Supports thermal tripping
Date: Wed, 31 Oct 2012 15:47:27 +0900
Message-id: <00f401cdb733$97e429a0$c7ac7ce0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QAAAg6wADTi5aA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd2GkxMCDHrfy1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mv6sNC25yVaxt/cDcwDiRo4uRk0NCwERi+oOvLBC2mMSFe+vZ
	uhi5OIQEpjNKTJ97ixnCmcckMePBa3aQKjYBXYlj67ewgtgiAtESfxr3gBUxCzQxSjTOXwTk
	cAB1cEusbg4CqeEU4JFY96cTLCws4Chx9LUeSJhFQFXi5pG7YCN5Bewkli++ygZhC0r8mHwP
	7CBmAS2J9TuPM0HY8hKb17wFGyMhoC7x6K8uxAVWEmfOTmSFKBGR2PfiHeMERqFZSCbNQjJp
	FpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMTPpHYwrmywOMQowMGoxMNr
	+K8/QIg1say4MvcQowQHs5IIb8mMCQFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZs9UgKEBNIT
	S1KzU1MLUotgskwcnFINjNMcFl048WvJBGYv7yK+Ep5TL8JTn277ZZPT1hf6byaztWjKvS0e
	3Bv8jh/fEcYVsyJFIrvL5OhN/Z4DMj8nXVNMjfuYvvTQqw3WZntX7rpZER9ZnWVSFledeXPv
	Qlneeq/cT9tPM7bUX9xfsWRR6pdDDn+CNwhyszoKxfrlteakTTZNrLFcqcRSnJFoqMVcVJwI
	AAwaH8teAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TMU urgently sends active-high signal (thermal trip) to PMU,
and thermal tripping by hardware logic i.e PMU is performed.
Thermal tripping means that PMU cut off the whole power of SoC
by controlling external voltage regulator.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 6ce6667..5672e95 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -53,6 +53,7 @@
 #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
 #define EXYNOS_TMU_GAIN_SHIFT          8
 #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
+#define EXYNOS_TMU_TRIP_EN             BIT(12)
 #define EXYNOS_TMU_CORE_ON             1
 #define EXYNOS_TMU_CORE_OFF            0
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
@@ -656,6 +657,9 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
        if (data->soc == SOC_ARCH_EXYNOS) {
                con |= pdata->noise_cancel_mode <<
EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
+
+               if (pdata->trigger_level3_en)
+                       con |= EXYNOS_TMU_TRIP_EN;
        }

        if (on) {
--
1.7.4.1

