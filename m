Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0GBLyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:54:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab0GBLys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:54:48 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Ettl <ettl.martin@gmx.de>,
       David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] scripts/dtc: Fix a resource leak
Date: Fri,  2 Jul 2010 13:52:14 +0200
Message-Id: <1278071534-9820-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Ettl <ettl.martin@gmx.de>

during a check of the current git head of the linux kernel with the
static code analysis tool cppcheck
(http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page)
the tool discovered a resource leak in linux-2.6/scripts/dtc/fstree.c.

Please refer the attached patch, that fixes the issue.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=15363
Signed-off-by: Martin Ettl <ettl.martin@gmx.de>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/dtc/fstree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/dtc/fstree.c b/scripts/dtc/fstree.c
index 766b269..8fe1bdf 100644
--- a/scripts/dtc/fstree.c
+++ b/scripts/dtc/fstree.c
@@ -77,6 +77,7 @@ static struct node *read_fstree(const char *dirname)
 		free(tmpnam);
 	}
 
+	closedir(d);
 	return tree;
 }
 
-- 
1.7.1

