Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2KUKKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:10:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45309 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2KUKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:10:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cb-50aca8a1ef52
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org
Cc: rjw@sisk.pl, keescook@chromium.org, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com
Subject: [PATCH] PM / devfreq: missing rcu_read_lock() added for
 find_device_opp()
Date: Wed, 21 Nov 2012 19:10:34 +0900
Message-id: <1353492634-10730-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <CAGXu5j+g8inUZV43GFQzs9KpRvjPGPTJsXinb4Y=wOuOf2jnVQ@mail.gmail.com>
References: <CAGXu5j+g8inUZV43GFQzs9KpRvjPGPTJsXinb4Y=wOuOf2jnVQ@mail.gmail.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t8zXd2FK9YEGOy9qWlxedccNovPvUcY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp4uvg1c8Fqvor7ndtYGhhbeboYOTkkBEwkHlx4xQxh
	i0lcuLeerYuRi0NIYBmjxM8n9xlhiqb8PMAEkVjEKLHm6jQWCKeFSeLQvQZ2kCo2AV2JrRvu
	soDYIgIyElOv7GcFsZkFqiTa5jwDqxEWCJE4+ukC2FQWAVWJu7fegtXwCnhI/Hg9jQlim4LE
	ryOrwOKcAsESMz89A7OFBAIkPq78CdUrIPFt8iGgXRxA9bISmw4wg9wjIXCbTeLGtutQ70hK
	HFxxg2UCo/ACRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGCHhKL2DcVWDxSFGAQ5GJR5e
	iX2rA4RYE8uKK3MPMUpwMCuJ8G6asiZAiDclsbIqtSg/vqg0J7X4EKMP0CUTmaVEk/OBsZJX
	Em9obGBsaGhpaGZqaWqAQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA6PU5Sl9Ec5nBf5/
	Nyk4p/Q8IT14msiUH9eOhWevfqcjKP/9S/Eb8Z/zbgYcNj26aZP541dr95TlbPHzCIk5tdlf
	0OlmTvE0Ls3vj1yVrIzz703XjTnPfoxhoa5CY0tbstSSqt3fHCWP5G/Kmq91dpfj14IvPtrb
	XSxeT+o0/iUsdD3gqNbRsulKLMUZiYZazEXFiQC4BCSDdAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAd25K9YEGOzs4ba4vGsOm8Xn3iOM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmPF38mrlgNV/F
	/c5tLA2MrTxdjJwcEgImElN+HmCCsMUkLtxbz9bFyMUhJLCIUWLN1WksEE4Lk8Shew3sIFVs
	AroSWzfcZQGxRQRkJKZe2c8KYjMLVEm0zXkGViMsECJx9NMFRhCbRUBV4u6tt2A1vAIeEj9e
	T4PapiDx68gqsDinQLDEzE/PwGwhgQCJjyt/Mk5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzjYn0nvYFzVYHGIUYCDUYmHV2Lf6gAh1sSy4srcQ4wSHMxKIrybpqwJEOJNSays
	Si3Kjy8qzUktPsToA3TVRGYp0eR8YCTmlcQbGpuYGVkamRmbmBsb4xBWEudt9kgJEBJITyxJ
	zU5NLUgtghnHxMEp1cBocX/RWznN3HTj1gwVF7YklZLluuVn/SrXTSxy2Kyes4zv+AxN11tM
	7PsUz9xcpf/pQrzD1cl1r9lT92o0Z0T6u7FqJN6+/urm3S/TLYt++VocCr/LHOSl8UHrQZig
	77eGGNuY/PlrxfPXHw28OqdVsmbhanfVk+ui96i+1uAXqmf+xr/nZpgSS3FGoqEWc1FxIgDx
	MORuowIAAA==
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
index 45e053e..e91cb22 100644
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
+	if (!ret)
+		ret = srcu_notifier_chain_register(nh, &devfreq->nb);
+	rcu_read_unlock();
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
+	if (!ret)
+		ret = srcu_notifier_chain_unregister(nh, &devfreq->nb);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
-- 
1.7.5.4

