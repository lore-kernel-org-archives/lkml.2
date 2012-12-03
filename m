Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2LCOg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43858 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab2LCOgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:48 -0500
Message-Id: <20121203143154.349483172@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 49/89] mtd: ofpart: Fix incorrect NULL check in
 parse_ofoldpart_partitions()
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


