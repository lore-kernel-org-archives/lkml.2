Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1DUBnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:43:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1DUBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:03 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KYppUXyytpAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=gOaop0idJN9xsWGo8AkA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014300.135521252@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:41:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/7] lockdep: Replace bad path error message with something sane
References: <20110421014153.126662477@goodmis.org>
Content-Disposition: inline; filename=0005-lockdep-Replace-bad-path-error-message-with-somethin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The message of "Bad BFS generated tree" is a bit confusing.
Replace it with a more sane error message.

Thanks to Peter Zijlstra for helping me come up with a better
message.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8646b8c..b531c66 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1381,7 +1381,7 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 		printk("\n");
 
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad BFS generated tree\n", __func__);
+			printk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 
-- 
1.7.2.3


