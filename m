Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2FZE24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:28:56 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:60035 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab2FZE2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:28:54 -0400
From: Josh Hunt <johunt@akamai.com>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        Josh Hunt <johunt@akamai.com>
Subject: [PATCH] cfq: reenable printing of sync/async queue info to blktrace cfqq log messages
Date: Mon, 25 Jun 2012 21:28:43 -0700
Message-Id: <1340684923-13167-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit afc24d49c1e5dbeef745c1c1246f5ae6ebd97c71 made the printing of the
sync/async queue info only available when you have CONFIG_CFQ_GROUP_IOSCHED
enabled. This re-enables it for the case when you do not have that config
option set.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 block/cfq-iosched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3c38536..8307b67 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -383,7 +383,9 @@ CFQ_CFQQ_FNS(wait_busy);
 
 #else
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
-	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
+	blk_add_trace_msg((cfqd)->queue, "cfq%d%c " fmt, (cfqq)->pid, \
+				cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
+				##args)
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 #endif
 #define cfq_log(cfqd, fmt, args...)	\
-- 
1.7.0.4

