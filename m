Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2FLPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:42:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2FLPjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:51 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 06/16] Export __lockdep_no_validate__
Date: Tue, 12 Jun 2012 08:39:12 -0700
Message-Id: <1339515562-14638-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache's garbage collection needs a way around lockdep; this might not
be the best way but it'll do for the moment.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/lockdep.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ea9ee45..a554e7f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2997,6 +2997,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
+EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
-- 
1.7.9.3.327.g2980b

