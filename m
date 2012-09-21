Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab2IUKrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:47:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab2IUKq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:46:29 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/9] Revert "mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix"
Date: Fri, 21 Sep 2012 11:46:16 +0100
Message-Id: <1348224383-1499-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1348224383-1499-1-git-send-email-mgorman@suse.de>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix
as it is replaced by a later patch in the series.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 4a77b4b..1c873bb 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -907,7 +907,8 @@ static unsigned long compact_zone_order(struct zone *zone,
 	INIT_LIST_HEAD(&cc.migratepages);
 
 	ret = compact_zone(zone, &cc);
-	*contended = cc.contended;
+	if (contended)
+		*contended = cc.contended;
 	return ret;
 }
 
-- 
1.7.9.2

