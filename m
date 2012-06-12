Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2FLPjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:39:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42433 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2FLPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:46 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 02/16] Fix ratelimit macro to compile in c99 mode
Date: Tue, 12 Jun 2012 08:39:08 -0700
Message-Id: <1339515562-14638-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/ratelimit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index e11ccb4..9ad57d3 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -20,7 +20,7 @@ struct ratelimit_state {
 #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
 									\
 	struct ratelimit_state name = {					\
-		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.lock		= __RAW_SPIN_LOCK_INITIALIZER(name.lock),\
 		.interval	= interval_init,			\
 		.burst		= burst_init,				\
 	}
-- 
1.7.9.3.327.g2980b

