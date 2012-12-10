Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2LJTmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20522 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2LJTmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:01 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-41-50c63b07d5db
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 01/13] i2c: add dummy inline functions for when
 CONFIG_OF_I2C(_MODULE) isn't defined
Date: Mon, 10 Dec 2012 20:41:27 +0100
Message-id: <1355168499-5847-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jQV1262MBBr/WaVhc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJOLvnJXrCZo+LbmjbWBsY29i5GTg4JAROJ7xN+MkLY
	YhIX7q1n62Lk4hASmM4oseHGJxYIp4NJYvqOf0wgVWwChhK9R/vAOkQEzCTedT4GK2IWeMgo
	8flVPwtIQlggS+Lw/t1gNouAqsT+41fZQGxeAVeJC1PagVZzAK1TkJgzyQYkzCngJvH6UCvY
	TCGgkh8z1zFPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyPY+8+kdjCubLA4xCjA
	wajEw6uhdSxAiDWxrLgy9xCjBAezkghvhARQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qA
	kEB6YklqdmpqQWoRTJaJg1OqgTHGa+kuvfWPQ17/Oy2uEVq1kf3/svepSivuFAWZ7k9pvrpt
	j9yng9+L61SknjYXhl9Ln6lz9nyH8Y6Xt9Y33O1v3awtUf7lnAcDT03FY/H+LKObgkqiaels
	J84+umy5m1G698iMLRPEmWMzi0v8fAM+lnYG6NlcXVM5wSdS4eZM7qXeERy5BUosxRmJhlrM
	RcWJANYBPGD6AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

If CONFIG_OF_I2C and CONFIG_OF_I2C_MODULE are undefined no declaration of
of_find_i2c_device_by_node and of_find_i2c_adapter_by_node will be
available. Add dummy inline functions to avoid compilation breakage.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/of_i2c.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index 1cb775f..cfb545c 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -29,6 +29,18 @@ static inline void of_i2c_register_devices(struct i2c_adapter *adap)
 {
 	return;
 }
+
+static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
+{
+	return NULL;
+}
+
+/* must call put_device() when done with returned i2c_adapter device */
+static inline struct i2c_adapter *of_find_i2c_adapter_by_node(
+						struct device_node *node)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF_I2C */
 
 #endif /* __LINUX_OF_I2C_H */
-- 
1.7.9.5

