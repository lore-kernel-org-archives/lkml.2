Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab0CQC7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:59:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:47870 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0CQC7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:59:03 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 2/3] kernel.h: fix wrong usage of __ratelimit()
Date: Wed, 17 Mar 2010 10:58:43 +0800
Message-Id: <1268794724-8665-3-git-send-email-yong.zhang@windriver.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
References: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
X-OriginalArrivalTime: 17 Mar 2010 02:58:49.0646 (UTC) FILETIME=[C4C74CE0:01CAC57D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ratelimit() rerurn 1 means we can go ahead.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7f07074..9365227 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -426,7 +426,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 		.burst = DEFAULT_RATELIMIT_BURST,       \
 	};                                              \
 							\
-	if (!__ratelimit(&_rs))                         \
+	if (__ratelimit(&_rs))                          \
 		printk(fmt, ##__VA_ARGS__);		\
 })
 #else
-- 
1.6.3.3

