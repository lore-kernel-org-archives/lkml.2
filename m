Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2JOLht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:37:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:48571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab2JOLhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:37:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="227002407"
From: dragos.tatulea@intel.com
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH 8/8] pstore: max out console log level during sysfs dump switch
Date: Mon, 15 Oct 2012 14:40:10 +0300
Message-Id: <1350301210-16953-9-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350301210-16953-1-git-send-email-dragos.tatulea@intel.com>
References: <1350301210-16953-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

Otherwise we might miss out on some pstore dumpers that use
printks below current log level.

Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
---
 fs/pstore/platform.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 25f59ed..e3ad13e 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -267,6 +267,7 @@ static DEFINE_SPINLOCK(dbg_lock);
 static int dbg_dump(void *data, u64 val)
 {
 	unsigned long flags;
+	int saved_loglevel;
 
 	switch (val) {
 	case KMSG_DUMP_PANIC:
@@ -276,7 +277,10 @@ static int dbg_dump(void *data, u64 val)
 	case KMSG_DUMP_HALT:
 	case KMSG_DUMP_POWEROFF:
 		spin_lock_irqsave(&dbg_lock, flags);
+		saved_loglevel = console_loglevel;
+		console_loglevel =  15;
 		kmsg_dump(val);
+		console_loglevel = saved_loglevel;
 		spin_unlock_irqrestore(&dbg_lock, flags);
 		return 0;
 	}
-- 
1.7.9.5

