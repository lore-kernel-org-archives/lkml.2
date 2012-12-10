Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2LJTmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17136 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LJTmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-35-50c63b1a77ae
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 06/13] of: Add empty of_find_device_by_node() function
 definition
Date: Mon, 10 Dec 2012 20:41:32 +0100
Message-id: <1355168499-5847-7-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQV0p62MBBg8P2Fhc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ+Tb7DUtDEXnHzI0cD4wfWLkZODgkBE4k1k9cwQthi
	EhfurWfrYuTiEBKYzihx9NF7Jging0mi8eYyZpAqNgFDid6jfWAdIgJmEu86H7OAFDEL9DFJ
	nLzzC2gsB4ewQLjE+esaIDUsAqoSF9sngNXzCrhK7H+8jwWkREJAQWLOJBuQMKeAm8TrQ61g
	JUJAJT9mrmOewMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkaw559J72Bc1WBxiFGA
	g1GJh1dD61iAEGtiWXFl7iFGCQ5mJRHeCAmgEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QA
	IYH0xJLU7NTUgtQimCwTB6dUA6P2Rw6dwMgNK6SNov5Mf/jwQv0tlsKVS5/L2VzimXUx6gTX
	g602bprTv9qKNy59tunWuhZpvbolt3013u1LOzv7i9nKE44WTx/YZalFsGT/KLqhN2W7a1aY
	8B4O17+WSbM0LVwTeyRLumeqv+FevmqiNKOV5b1pbTuvztLOMzfdXvvnz/lIrbdKLMUZiYZa
	zEXFiQABjmOJ+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows users to be compiled without excluding this function
call with preprocessor directives when CONFIG_OF_DEVICE is disabled.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/of_platform.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index b47d204..d8f587f 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -96,6 +96,13 @@ extern int of_platform_populate(struct device_node *root,
 				struct device *parent);
 #endif /* CONFIG_OF_ADDRESS */
 
+#else  /* CONFIG_OF_DEVICE */
+static inline struct platform_device *of_find_device_by_node(
+					struct device_node *np)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF_DEVICE */
 
 #if !defined(CONFIG_OF_ADDRESS)
-- 
1.7.9.5

