Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1AKIv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:51:26 -0500
Received: from mail-yw0-f66.google.com ([209.85.213.66]:44638 "EHLO
	mail-yw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1AKIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:51:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xA5aG6m96k3IbWIyrKuCHxh650A/P8+pC/LAHckpTGP3jYYTkV9jPFhsraf2F3BF3S
         M7OLivElBVVEHNQH0GuPxAFM7S7oqGV0ubUzmhnCcdLWpnKy+kVfNQ+xNvz8BwnKflsD
         UtYIuBlAeB6sGAjAxFQ2jwn76MYf8AmEwKsYg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 1/2] memcg: remove unnecessary BUG_ON
Date: Tue, 11 Jan 2011 17:51:11 +0900
Message-Id: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memcg in unmap_and_move checks BUG_ON of charge.
mem_cgroup_prepare_migration returns either 0 or -ENOMEM.
If it returns -ENOMEM, it jumps out unlock without the check.
If it returns 0, it can pass BUG_ON. So it's meaningless.
Let's remove it.

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/migrate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b8a32da..8f0f131 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -667,7 +667,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		rc = -ENOMEM;
 		goto unlock;
 	}
-	BUG_ON(charge);
 
 	if (PageWriteback(page)) {
 		if (!force || !sync)
-- 
1.7.0.4

