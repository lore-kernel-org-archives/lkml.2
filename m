Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2JaFtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:49:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49749 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2JaFtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:49:15 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-68-5090bbd99dee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] cpufreq: remove the unnecessary initialization of a local
 variable
Date: Wed, 31 Oct 2012 14:49:13 +0900
Message-id: <000901cdb72b$74a6af10$5df40d30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23K3RppeJQZsbERtO9oYgt6fFsCg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jAd1buycEGBxtYLN42vSD3eLyrjls
	Fp97jzA6MHt83iQXwBjFZZOSmpNZllqkb5fAlXGtezNjwQ2OipuP5rA1MP5m62Lk5JAQMJFY
	MekEO4QtJnHh3nqgOBeHkMAiRomdi5uYIZxfjBJfT2xjBaliE1CT+PLlMFiHiICZxIfOpcwg
	NrNApUTbnDlgcWGBUIlNnStYQGwWAVWJ1XvPg23jFbCVOHPjJzOELSjxY/I9FoheLYn1O48z
	QdjyEpvXvAWq4QC6SF3i0V9diFV6Er8OvIEqEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZ
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcrM+kdjCubLA4xCjAwajEw2v4rz9AiDWxrLgy
	9xCjBAezkghvyYwJAUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNTUwtSi2Cy
	TBycUg2M6rWZObMOtXY2TYlPnpgqUmN6/P2EJ2Knjpd/mBRw5cyZu/pOyw+Hx+6XdTj2tvqY
	Us/hJ+mJ+8K/FTfzF2TstJ7tLPykbt9zEROWm+uP76qUO9HpeudOtYgD/wJnz+K+ZblLD86c
	ONuadYaO1EO9tcdjp7wJ+HQ51/qHZ2nNhpeNf7V7V265qcRSnJFoqMVcVJwIAJkTkldSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary initializer for the 'ret' variable.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 261ef65..4e9fcc5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -404,7 +404,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 static ssize_t store_##file_name					\
 (struct cpufreq_policy *policy, const char *buf, size_t count)		\
 {									\
-	unsigned int ret = -EINVAL;					\
+	unsigned int ret;						\
 	struct cpufreq_policy new_policy;				\
 									\
 	ret = cpufreq_get_policy(&new_policy, policy->cpu);		\
@@ -459,7 +459,7 @@ static ssize_t show_scaling_governor(struct cpufreq_policy *policy, char *buf)
 static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
 					const char *buf, size_t count)
 {
-	unsigned int ret = -EINVAL;
+	unsigned int ret;
 	char	str_governor[16];
 	struct cpufreq_policy new_policy;
 
-- 
1.7.1


