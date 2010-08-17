Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0HQGiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:38:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60391 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0HQGiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pZxYIylHBtm0oMmkH5L0a0TM8qlKWmfdZ/iSp1zqxMlIireC2cALzZVPCDD7eBHP33
         PWNXdQBTr2c8JN9DXLB2QJPFv3pWSUsHDmvFHyGGyIud+c0+sKeDv26gMqpPhBCtYGWh
         z1fTOS/77DzG4Kt/wl6Ci9oGa3luaJlPiBrPc=
From: Changli Gao <xiaosuo@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] timer: initialize the field slack of timer_list
Date: Tue, 17 Aug 2010 14:37:44 +0800
Message-Id: <1282027064-7481-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIMER_INITIALIZER() should initialize the field slack of timer_list as
__init_timer() does.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 include/linux/timer.h |    1 +
 1 file changed, 1 insertion(+)
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 38cf093..81de484 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -54,6 +54,7 @@ extern struct tvec_base boot_tvec_bases;
 		.expires = (_expires),				\
 		.data = (_data),				\
 		.base = &boot_tvec_bases,			\
+		.slack = -1,					\
 		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
