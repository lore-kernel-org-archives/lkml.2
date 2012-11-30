Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768933Ab2K3TPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:15:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:59378 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992908Ab2K3TCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 18/54] mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()
Date: Fri, 30 Nov 2012 10:55:49 -0800
Message-Id: <20121130185209.728623465@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 5a6ea4af0907f995dc06df21a9c9ef764c7cd3bc upstream.

The pointer returned by kzalloc should be tested for NULL
to avoid potential NULL pointer dereference later. Incorrect
pointer was being tested for NULL. Bug introduced by commit fbcf62a3
(mtd: physmap_of: move parse_obsolete_partitions to become separate
parser).
This patch fixes this bug.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ofpart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -121,7 +121,7 @@ static int parse_ofoldpart_partitions(st
 	nr_parts = plen / sizeof(part[0]);
 
 	*pparts = kzalloc(nr_parts * sizeof(*(*pparts)), GFP_KERNEL);
-	if (!pparts)
+	if (!*pparts)
 		return -ENOMEM;
 
 	names = of_get_property(dp, "partition-names", &plen);


