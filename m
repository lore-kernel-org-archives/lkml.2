Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JRX0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:26:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2JRXTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:54 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/2] timer: add setup_timer_deferrable() macro
Date: Fri, 19 Oct 2012 08:18:27 +0900
Message-Id: <1350602308-2120-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350602308-2120-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1350602308-2120-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some users of deferrable timer. Because of lacking of
handy initializer, they should initialize deferrable timer fumblingly.
We might do better with new setup_timer_deferrable() macro.
So add it.

Following patch will makes some users of init_timer_deferrable() use
this handy macro.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 8c5a197..5950276 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -151,6 +151,8 @@ static inline void init_timer_on_stack_key(struct timer_list *timer,
 
 #define setup_timer(timer, fn, data)					\
 	__setup_timer((timer), (fn), (data), 0)
+#define setup_timer_deferrable(timer, fn, data)				\
+	__setup_timer((timer), (fn), (data), TIMER_DEFERRABLE)
 #define setup_timer_on_stack(timer, fn, data)				\
 	__setup_timer_on_stack((timer), (fn), (data), 0)
 #define setup_deferrable_timer_on_stack(timer, fn, data)		\
-- 
1.7.9.5

