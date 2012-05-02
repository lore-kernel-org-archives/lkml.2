Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2EBC1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:27:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46094 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab2EBC1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:27:39 -0400
From: Matt Turner <mattst88@gmail.com>
To: linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: [PATCH 2/4] alpha: properly define get/set_rtc_time on Marvel/SMP
Date: Tue,  1 May 2012 22:27:22 -0400
Message-Id: <1335925644-5192-2-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
References: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The marvel_get_rtc_time and marvel_set_rtc_time are static, but they're
available through Marvel's machine vector.

Reported-by: Raúl Porcel <armin76@gentoo.org>
Signed-off-by: Matt Turner <mattst88@gmail.com>
---
Ivan: I'd appreciate it if you could confirm that this is okay. It's not
clear to me how the marvel_get/set_rtc_time functions could have ever been
called externally.

 arch/alpha/include/asm/rtc.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/asm/rtc.h b/arch/alpha/include/asm/rtc.h
index 1f7fba6..d70408d 100644
--- a/arch/alpha/include/asm/rtc.h
+++ b/arch/alpha/include/asm/rtc.h
@@ -1,14 +1,10 @@
 #ifndef _ALPHA_RTC_H
 #define _ALPHA_RTC_H
 
-#if defined(CONFIG_ALPHA_GENERIC)
+#if defined(CONFIG_ALPHA_MARVEL) && defined(CONFIG_SMP) \
+ || defined(CONFIG_ALPHA_GENERIC)
 # define get_rtc_time		alpha_mv.rtc_get_time
 # define set_rtc_time		alpha_mv.rtc_set_time
-#else
-# if defined(CONFIG_ALPHA_MARVEL) && defined(CONFIG_SMP)
-#  define get_rtc_time		marvel_get_rtc_time
-#  define set_rtc_time		marvel_set_rtc_time
-# endif
 #endif
 
 #include <asm-generic/rtc.h>
-- 
1.7.3.4

