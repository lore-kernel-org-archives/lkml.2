Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2LJTmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:42:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17113 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LJTmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:08 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0d-50c63b0fb209
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 03/13] OF: define of_*_cmp() macros also if CONFIG_OF isn't
 set
Date: Mon, 10 Dec 2012 20:41:29 +0100
Message-id: <1355168499-5847-4-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQV1+62MBBrs7uS0u75rDZtGzYSur
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmHN8xnLdjEW3Hld3YD42zuLkZODgkBE4mVrUdZIWwx
	iQv31rN1MXJxCAlMZ5T4MX0pM4TTwSTR/uYwI0gVm4ChRO/RPjBbRMBM4l3nYxaQImaBh4wS
	n1/1s4AkhAVCJT4e/ARWxCKgKnGicQ4biM0r4CpxsPsDkM0BtE5BYs4kG5Awp4CbxOtDrWDl
	QkAlP2auY57AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRrDvn0nvYFzVYHGIUYCD
	UYmHV0PrWIAQa2JZcWXuIUYJDmYlEd4ICaAQb0piZVVqUX58UWlOavEhRmkOFiVx3maPlAAh
	gfTEktTs1NSC1CKYLBMHp1QD4zaHZY813T8KftzpNoU9uslpQZbAvNLy17Prrn5ddb2777rl
	vCOLumKq0/LktwuZL39Wt0Z3tmsYl8SXK1XWc1Y+F7mwaf8Kdq/2pc6ZCyR04z/U23OoXJnF
	lfL5pN6P7MVPvZ3SbmzUjpo6RcAp8dK5R3Pu3Qo48e1y0Yxom4RGhaVztWOYrZRYijMSDbWY
	i4oTAevJe775AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

of_*_cmp() macros do not depend on any OF functions and can be defined also
if CONFIG_OF isn't set. Also include linux/string.h, required by those
macros.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/of.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 9ba8cf1..38d4b1a 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -85,6 +85,14 @@ static inline struct device_node *of_node_get(struct device_node *node)
 static inline void of_node_put(struct device_node *node) { }
 #endif /* !CONFIG_OF_DYNAMIC */
 
+/* Default string compare functions, Allow arch asm/prom.h to override */
+#if !defined(of_compat_cmp)
+#include <linux/string.h>
+#define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
+#define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
+#define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
+#endif
+
 #ifdef CONFIG_OF
 
 /* Pointer for first entry in chain of all nodes. */
@@ -143,13 +151,6 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 #define OF_ROOT_NODE_SIZE_CELLS_DEFAULT 1
 #endif
 
-/* Default string compare functions, Allow arch asm/prom.h to override */
-#if !defined(of_compat_cmp)
-#define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
-#define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
-#define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
-#endif
-
 /* flag descriptions */
 #define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
 #define OF_DETACHED	2 /* node has been detached from the device tree */
-- 
1.7.9.5

