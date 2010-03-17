Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab0CQC7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:59:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:47869 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0CQC7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:59:02 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [RFC PATCH 3/3] ratelimit: Fix return value when fail to get lock
Date: Wed, 17 Mar 2010 10:58:44 +0800
Message-Id: <1268794724-8665-4-git-send-email-yong.zhang@windriver.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
References: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
X-OriginalArrivalTime: 17 Mar 2010 02:58:51.0380 (UTC) FILETIME=[C5CFE340:01CAC57D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From log of commit edaac8e3167501cda336231d00611bf59c164346,
It seems that we want to suppress the callback when trylock
fails.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/ratelimit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 29a10b3..358638f 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -40,7 +40,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	 * the entity that is holding the lock already:
 	 */
 	if (!spin_trylock_irqsave(&rs->lock, flags))
-		return 1;
+		return 0;
 
 	if (!rs->begin)
 		rs->begin = jiffies;
-- 
1.6.3.3

