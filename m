Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2GWXzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:55:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32924 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2GWXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:51:45 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        joe@perches.com
Subject: [Bcache v15 02/16] Fix ratelimit macro to compile in c99 mode
Date: Mon, 23 Jul 2012 16:50:45 -0700
Message-Id: <1343087459-17645-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343087459-17645-1-git-send-email-koverstreet@google.com>
References: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/ratelimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.7.3

