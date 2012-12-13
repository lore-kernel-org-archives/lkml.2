Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2LMOHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2LMOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 103/241] mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()
Date: Thu, 13 Dec 2012 11:57:48 -0200
Message-Id: <1355407206-17100-104-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 5a6ea4af0907f995dc06df21a9c9ef764c7cd3bc upstream.

The pointer returned by kzalloc should be tested for NULL
to avoid potential NULL pointer dereference later. Incorrect
pointer was being tested for NULL. Bug introduced by commit fbcf62a3
(mtd: physmap_of: move parse_obsolete_partitions to become separate
parser).
This patch fixes this bug.

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mtd/ofpart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index 64be8f0..d9127e2 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -121,7 +121,7 @@ static int parse_ofoldpart_partitions(struct mtd_info *master,
 	nr_parts = plen / sizeof(part[0]);
 
 	*pparts = kzalloc(nr_parts * sizeof(*(*pparts)), GFP_KERNEL);
-	if (!pparts)
+	if (!*pparts)
 		return -ENOMEM;
 
 	names = of_get_property(dp, "partition-names", &plen);
-- 
1.7.9.5

