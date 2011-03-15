Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1COWxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:53:38 -0400
Received: from shutemov.name ([188.40.19.243]:49777 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1COWx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:27 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Neil Brown <neilb@suse.de>,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH 04/13] dm: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:16 +0200
Message-Id: <1300229605-14499-4-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Neil Brown <neilb@suse.de>
Cc: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org
---
 drivers/md/dm-log-userspace-base.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index aa2e0c3..1021c89 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -394,8 +394,7 @@ static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
 			group[count] = fe->region;
 			count++;
 
-			list_del(&fe->list);
-			list_add(&fe->list, &tmp_list);
+			list_move(&fe->list, &tmp_list);
 
 			type = fe->type;
 			if (count >= MAX_FLUSH_GROUP_COUNT)
-- 
1.7.4.1

