Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab0GOLwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 07:52:37 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:41200 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab0GOLwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 07:52:36 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] list debugging: warn when deleting a deleted entry
Date: Thu, 15 Jul 2010 14:51:44 +0300
Message-Id: <9a1204cb6eeb6d492b525b03182948635e03c4f9.1279194362.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the magic LIST_POISON* values to detect an incorrect use of list_del on a
deleted entry. This DEBUG_LIST specific warning is easier to understand than
the generic Oops message caused by LIST_POISON dereference.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
Posting this again.

This patch could have saved me an hour or so. I guess it can be usefull to 
others as well. Please pick this up.

 lib/list_debug.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 1a39f4e..344c710 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -43,6 +43,12 @@ EXPORT_SYMBOL(__list_add);
  */
 void list_del(struct list_head *entry)
 {
+	WARN(entry->next == LIST_POISON1,
+		"list_del corruption, next is LIST_POISON1 (%p)\n",
+		LIST_POISON1);
+	WARN(entry->next != LIST_POISON1 && entry->prev == LIST_POISON2,
+		"list_del corruption, prev is LIST_POISON2 (%p)\n",
+		LIST_POISON2);
 	WARN(entry->prev->next != entry,
 		"list_del corruption. prev->next should be %p, "
 		"but was %p\n", entry, entry->prev->next);
-- 
1.7.1

