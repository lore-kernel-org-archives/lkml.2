Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab0D3SYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:24:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab0D3RW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:29 -0400
Date: Thu, 29 Apr 2010 21:45:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 2/2] workqueues: export keventd_wq
Message-ID: <20100429194545.GC17280@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com> <20100429194447.GA17280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429194447.GA17280@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export keventd_wq. Otherwise, any helper on top of queue_work() has
to be copy-and-pasted to create the version which uses keventd_wq.

Note: we can do more cleanups with this change and kill EXPORT_SYMBOLs,
almost any function which currently uses keventd_wq can become the
trivial inline.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- 34-rc1/include/linux/workqueue.h~EXPORT_KEVENT_WQ	2009-12-18 19:05:38.000000000 +0100
+++ 34-rc1/include/linux/workqueue.h	2010-04-29 21:25:12.000000000 +0200
@@ -12,6 +12,7 @@
 #include <asm/atomic.h>
 
 struct workqueue_struct;
+extern struct workqueue_struct *keventd_wq;
 
 struct work_struct;
 typedef void (*work_func_t)(struct work_struct *work);
--- 34-rc1/kernel/workqueue.c~EXPORT_KEVENT_WQ	2010-04-29 21:08:32.000000000 +0200
+++ 34-rc1/kernel/workqueue.c	2010-04-29 21:23:46.000000000 +0200
@@ -717,7 +717,8 @@ int cancel_delayed_work_sync(struct dela
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
-static struct workqueue_struct *keventd_wq __read_mostly;
+struct workqueue_struct *keventd_wq __read_mostly;
+EXPORT_SYMBOL(keventd_wq);
 
 /**
  * schedule_work - put work task in global workqueue

