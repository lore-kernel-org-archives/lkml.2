Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2LJTqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:46:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17097 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LJTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-01-50c63b0bdbca
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 02/13] of: add a dummy inline function for when CONFIG_OF
 is not defined
Date: Mon, 10 Dec 2012 20:41:28 +0100
Message-id: <1355168499-5847-3-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQV1u62MBBm8PSVtc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJenj3NXHCOrWJ/9w32BsY9rF2MnBwSAiYSPw+uYISw
	xSQu3FvP1sXIxSEkMJ1RYvvjfawQTgeTxJ/Jk8E62AQMJXqP9oF1iAiYSbzrfMwCUsQs8JBR
	4vOrfhaQhLBAnMSHs3uZQWwWAVWJQ/PuADVzcPAKuEq0XtQDMSUEFCTmTLIBqeAUcJN4fagV
	bKQQUMWPmeuYJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR7Ptn0jsYVzVYHGIU
	4GBU4uHV0DoWIMSaWFZcmXuIUYKDWUmEN0ICKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMl
	QEggPbEkNTs1tSC1CCbLxMEp1cCYZKQql/evUjnat0zw+ETTK14Wuu/ya/Nmf2DU+vX0/9f+
	P/Vz/x7L7770XseHIXVP/0Klz08/vz1QvecRw5YA1m65a4KyGkunud5TK95bXr9js5xPj5SH
	wbJvV4402IjHGPi09ry5xG4xa2sJa+R/I777OXohaz44LpmTwJHQ8vFJof08DRMlluKMREMt
	5qLiRAC8XYIb+QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

If CONFIG_OF isn't defined, no declaration of of_get_parent will be found
and compilation can fail. This patch adds a dummy inline function
definition to fix the problem.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/of.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index b4e50d5..9ba8cf1 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -427,6 +427,11 @@ static inline int of_parse_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline struct device_node *of_get_parent(const struct device_node *np)
+{
+	return NULL;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
-- 
1.7.9.5

