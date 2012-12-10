Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2LJTmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17124 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LJTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:11 -0500
X-AuditID: cbfee61b-b7f616d00000319b-19-50c63b12e07d
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 04/13] OF: make a function pointer argument const
Date: Mon, 10 Dec 2012 20:41:30 +0100
Message-id: <1355168499-5847-5-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jQV0h62MBBosWWVhc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIO/25iKpguXLF7/inWBsZ//F2MnBwSAiYS5zu/skDY
	YhIX7q1n62Lk4hASmM4oMaXzHDOE08EkcfDfamaQKjYBQ4neo32MILaIgJnEu87HLCBFzAIP
	GSU+v+oHGyUs4Cpx/fxMdhCbRUBVouvBPrA4L1B88eSvQM0cQOsUJOZMsgEJcwq4Sbw+1Ao2
	Uwio5MfMdcwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAj2/jPpHYyrGiwOMQpw
	MCrx8GpoHQsQYk0sK67MPcQowcGsJMIbIQEU4k1JrKxKLcqPLyrNSS0+xCjNwaIkztvskRIg
	JJCeWJKanZpakFoEk2Xi4JRqYNTadX/yg7jSvxlT7qz4up9xdtaK9te5kgxLbrxTWMzjearU
	JbtgyqrfS59Ir6ubznl8kuhZq7K1TZVWVZumOV7q//pB0b1gV+JGE8Y7i2rLAvZNTtq7ZY/W
	yp1a9348sjXzyRH0mpzxY1F8+Ga1idtOHKy027nb7JHx7QPiZhM7C7Zf+xam9OW9EktxRqKh
	FnNRcSIAHhF6CfoBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

The "struct device_node *" argument of of_parse_phandle_*() can be const.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/of/base.c  |    4 ++--
 include/linux/of.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index af3b22a..c180205 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -894,7 +894,7 @@ EXPORT_SYMBOL_GPL(of_property_count_strings);
  * of_node_put() on it when done.
  */
 struct device_node *
-of_parse_phandle(struct device_node *np, const char *phandle_name, int index)
+of_parse_phandle(const struct device_node *np, const char *phandle_name, int index)
 {
 	const __be32 *phandle;
 	int size;
@@ -939,7 +939,7 @@ EXPORT_SYMBOL(of_parse_phandle);
  * To get a device_node of the `node2' node you may call this:
  * of_parse_phandle_with_args(node3, "list", "#list-cells", 1, &args);
  */
-int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
+int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
 				const char *cells_name, int index,
 				struct of_phandle_args *out_args)
 {
diff --git a/include/linux/of.h b/include/linux/of.h
index 38d4b1a..2fb0dbe 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -256,10 +256,10 @@ extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
 	const struct of_device_id *matches, const struct device_node *node);
 extern int of_modalias_node(struct device_node *node, char *modalias, int len);
-extern struct device_node *of_parse_phandle(struct device_node *np,
+extern struct device_node *of_parse_phandle(const struct device_node *np,
 					    const char *phandle_name,
 					    int index);
-extern int of_parse_phandle_with_args(struct device_node *np,
+extern int of_parse_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct of_phandle_args *out_args);
 
@@ -412,7 +412,7 @@ static inline int of_property_match_string(struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline struct device_node *of_parse_phandle(struct device_node *np,
+static inline struct device_node *of_parse_phandle(const struct device_node *np,
 						   const char *phandle_name,
 						   int index)
 {
-- 
1.7.9.5

