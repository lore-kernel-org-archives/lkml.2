Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2KVSq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8903 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab2KVSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:55 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ec-50adc7f18911
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: serge@hallyn.com
Cc: myungjoo.ham@gmail.com, linux-pm@vger.kernel.org, rjw@sisk.pl,
        keescook@chromium.org, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PM / devfreq: missing rcu_read_lock() added for
 find_device_opp()
Date: Thu, 22 Nov 2012 15:36:32 +0900
Message-id: <1353566192-7079-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <20121121134621.GA30575@mail.hallyn.com>
References: <20121121134621.GA30575@mail.hallyn.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t8zXd2Px9cGGEy5KWZxedccNovPvUcY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4MronDOLtWA1X8XsJwfYGhhbeboYOTkkBEwk5rycyQZh
	i0lcuLceyObiEBJYxijxe+t1ZpiiHXNus0IkFjFKzJ76mBHCaWGS6G7exgpSxSagK7F1w10W
	EFtEQESi9cgSZpAiZoEpjBLz1y0CGyUsECJx9NMFoG4ODhYBVYkX38pBwrwC7hKbvz5lh9im
	IPHryCqwmZwCphIfGueAtQoBXXH+wlkmEJtFQEDi2+RDLCBjJARkJTYdAFslIXCbTeLFGpir
	JSUOrrjBMoFReAEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MkHCU3sG4qsHiEKMAB6MS
	D2+GwdoAIdbEsuLK3EOMEhzMSiK8iwqAQrwpiZVVqUX58UWlOanFhxh9gC6ZyCwlmpwPjJW8
	knhDYwNjQ0NLQzNTS1MDHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhjL1l+/eKXkYtHN
	+jNbDG54tV5KYHi8K2BpZfGhjxHr5Ofrre9fvVzY4+w7Q25796U3b3jcNVuxYOr8RwLCXQfy
	TTPPXXcTanf78U2wNnXT0mK9Du515jve1h9qiypPexW19s5ZVs+KhQpJpttrmDZ+WHn39M1Z
	Kw/cXL3rk0DHwbQd51ju1juLKbEUZyQaajEXFScCAGIexOt0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAd2Px9cGGCzdy2NxedccNovPvUcY
	HZg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Jwzi7VgNV/F
	7CcH2BoYW3m6GDk5JARMJHbMuc0KYYtJXLi3nq2LkYtDSGARo8TsqY8ZIZwWJonu5m1gVWwC
	uhJbN9xlAbFFBEQkWo8sYQYpYhaYwigxf90iZpCEsECIxNFPF4C6OThYBFQlXnwrBwnzCrhL
	bP76lB1im4LEryOrwGZyCphKfGicA9YqBHTR+QtnmSYw8i5gZFjFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERzsz6R3MK5qsDjEKMDBqMTDm2GwNkCINbGsuDL3EKMEB7OSCO+iAqAQb0pi
	ZVVqUX58UWlOavEhRh+goyYyS4km5wMjMa8k3tDYxMzI0sjM2MTc2BiHsJI4b7NHSoCQQHpi
	SWp2ampBahHMOCYOTqkGxlTpLvMSkXTjP9vyOWVTzGRz716d1bX1aPfJpAXBt27ftb7Ol3HM
	+NDJeVfrcsz/VT1IeMyrynWmcs+NlKInedUGwZdLgn7XWqQXTyy9vrBVpVg2+l/FvKvT/eyW
	bMqvipUJl/l66OYLocnZIcvXLXu75Z9XkdrEPd77nvrP7JeyipWqc/i6T4mlOCPRUIu5qDgR
	AA8LBUCjAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

opp_get_notifier() uses find_device_opp(), which requires to
held rcu_read_lock. In order to keep the notifier-header
valid, we have added rcu_read_lock().

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/devfreq/devfreq.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 1388d46..5275883 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1023,11 +1023,18 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
  */
 int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
 {
-	struct srcu_notifier_head *nh = opp_get_notifier(dev);
+	struct srcu_notifier_head *nh;
+	int ret = 0;
 
+	rcu_read_lock();
+	nh = opp_get_notifier(dev);
 	if (IS_ERR(nh))
-		return PTR_ERR(nh);
-	return srcu_notifier_chain_register(nh, &devfreq->nb);
+		ret = PTR_ERR(nh);
+	rcu_read_unlock();
+	if (!ret)
+		ret = srcu_notifier_chain_register(nh, &devfreq->nb);
+
+	return ret;
 }
 
 /**
@@ -1042,11 +1049,18 @@ int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
  */
 int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
 {
-	struct srcu_notifier_head *nh = opp_get_notifier(dev);
+	struct srcu_notifier_head *nh;
+	int ret = 0;
 
+	rcu_read_lock();
+	nh = opp_get_notifier(dev);
 	if (IS_ERR(nh))
-		return PTR_ERR(nh);
-	return srcu_notifier_chain_unregister(nh, &devfreq->nb);
+		ret = PTR_ERR(nh);
+	rcu_read_unlock();
+	if (!ret)
+		ret = srcu_notifier_chain_unregister(nh, &devfreq->nb);
+
+	return ret;
 }
 
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
-- 
1.7.5.4

