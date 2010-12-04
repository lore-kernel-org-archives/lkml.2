Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0LDAOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:14:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0LDAOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:14:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=M9kQcHHzOwRajwecPJbgtbF2vfW1/f/bLjwXVd1dJeEMOHv9h97bdbpJlCNb93czz
	e+KaXZJRTJOl3ni1m28Aw==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 10/15] ftrace: fix event alignment: jbd2:*
Date: Fri,  3 Dec 2010 16:13:24 -0800
Message-Id: <1291421609-14665-11-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/trace/events/jbd2.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 7447ea9..2f9f362 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -41,15 +41,15 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_STRUCT__entry(
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
-		__field(	char,	sync_commit		  )
 		__field(	int,	transaction		  )
+		__field(	char,	sync_commit		  )
 	),
 
 	TP_fast_assign(
 		__entry->dev_major	= MAJOR(journal->j_fs_dev->bd_dev);
 		__entry->dev_minor	= MINOR(journal->j_fs_dev->bd_dev);
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 		__entry->transaction	= commit_transaction->t_tid;
+		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 	),
 
 	TP_printk("dev %d,%d transaction %d sync %d",
@@ -93,17 +93,17 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_STRUCT__entry(
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
-		__field(	char,	sync_commit		  )
 		__field(	int,	transaction		  )
 		__field(	int,	head		  	  )
+		__field(	char,	sync_commit		  )
 	),
 
 	TP_fast_assign(
 		__entry->dev_major	= MAJOR(journal->j_fs_dev->bd_dev);
 		__entry->dev_minor	= MINOR(journal->j_fs_dev->bd_dev);
-		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 		__entry->transaction	= commit_transaction->t_tid;
 		__entry->head		= journal->j_tail_sequence;
+		__entry->sync_commit = commit_transaction->t_synchronous_commit;
 	),
 
 	TP_printk("dev %d,%d transaction %d sync %d head %d",
-- 
1.7.3.1

