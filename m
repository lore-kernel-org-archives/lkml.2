Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0IGOev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:34:51 -0400
Received: from www.tglx.de ([62.245.132.106]:43945 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab0IGOd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:58 -0400
Message-Id: <20100907125057.086367802@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 25/30] drivers/macintosh/adb: Do not claim that the semaphore
	is a mutex
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-mac-adb-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User DEFINE_SEMAPHORE() instead of DECLARE_MUTEX()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

---
 drivers/macintosh/adb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/macintosh/adb.c
===================================================================
--- linux-2.6.orig/drivers/macintosh/adb.c
+++ linux-2.6/drivers/macintosh/adb.c
@@ -83,7 +83,7 @@ static struct adb_driver *adb_controller
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
-static DECLARE_MUTEX(adb_probe_mutex);
+static DEFINE_SEMAPHORE(adb_probe_mutex);
 static int sleepy_trackpad;
 static int autopoll_devs;
 int __adb_probe_sync;


