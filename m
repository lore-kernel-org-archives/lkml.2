Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033283Ab2I1Vgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:36:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423351Ab2I1Vg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/12] tty/console: fix warnings in drivers/tty/serial/kgdboc.c
Date: Fri, 28 Sep 2012 23:36:14 +0200
Message-Id: <1348868177-21205-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Cfqt7UvwbYX9gMqm2lDc8Sq7+SuSpUVWWJ8OdhxNULK
 cDBxPXAvoTu9bcTTz1bVuftmxDTKlsZBqAXeBS9S7E474wLssM
 m/8nmx4RLyaCEOtyzluQXlTROjAJ9jAqPsPMZuhA/JqrdFbb5g
 BllUCMOkHGfcEQ54jDe4TgZ2AIe+Bss2iM5gvVQx+IG7vewE4p
 T2SPfJFh8VMCjcXZ6i8DRxIJIoJmzobpfhaGfhQND/+qjiEuFD
 nVhmrcW6wHqY11nr7IX49gOYxasbSLUVfFzA9YUqJj/7WB5ERO
 bdwoSRzj53oPTW/qqZSjdR3DUqHhbVIC3h2oafUT0hSWYvKHon
 NIYuTL5+wfFh72Uf5RWFh4e91Jprgr9yf4G/79fcZFrSlcZnpE
 ZpseHSS/9uSyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The con_debug_leave/con_debug_enter functions are stubbed out
by defining them to (0), which causes harmless build warnings.
Using proper inline functions is the normal way to deal with
this.

Without this patch, building the ARM bcm2835_defconfig results in:

drivers/tty/serial/kgdboc.c: In function 'kgdboc_pre_exp_handler':
drivers/tty/serial/kgdboc.c:279:3: warning: statement with no effect [-Wunused-value]
drivers/tty/serial/kgdboc.c: In function 'kgdboc_post_exp_handler':
drivers/tty/serial/kgdboc.c:293:3: warning: statement with no effect [-Wunused-value]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/console.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index 7201ce4..dedb082 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -83,8 +83,14 @@ void give_up_console(const struct consw *sw);
 int con_debug_enter(struct vc_data *vc);
 int con_debug_leave(void);
 #else
-#define con_debug_enter(vc) (0)
-#define con_debug_leave() (0)
+static inline int con_debug_enter(struct vc_data *vc)
+{
+	return 0;
+}
+static inline int con_debug_leave(void)
+{
+	return 0;
+}
 #endif
 
 /* scroll */
-- 
1.7.10

