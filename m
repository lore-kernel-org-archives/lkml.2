Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2F0QBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:01:10 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab2F0P6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:14 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/16] UBI: Fastmap: Address a TODO
Date: Wed, 27 Jun 2012 17:57:45 +0200
Message-Id: <1340812676-14460-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use an aggregate data structure because fastmaps
internals parts do not have fixed positions.
They depends on the number of avaliable PEBs.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index a596cef..c2434cd 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -535,10 +535,6 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	if (fm_pos >= fm_size)
 		goto fail_bad;
 
-	/* TODO: this is difficult to read. Can we please have instead an
-	 * aggregate data structure? I did not think hard on it may be you have
-	 * a good reason for this difficult style, but on the first glance it
-	 * does not look like. And where are all the endiness stuff?  */
 	fmhdr = (struct ubi_fm_hdr *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmhdr);
 	if (fm_pos >= fm_size)
-- 
1.7.6.5

