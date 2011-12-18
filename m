Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab1LRAFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 19:05:35 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23651 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1LRAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:05:32 -0500
Date: Sun, 18 Dec 2011 01:05:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: x86@kernel.org
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, mc146818rtc.h: use do{}while(0) for empty
 lock_cmos()/unlock_cmos()
Message-ID: <alpine.LNX.2.00.1112180103130.21784@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-47864580-1324166731=:21784"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-47864580-1324166731=:21784
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

gcc noticed (when using -Wempty-body) that our use of lock_cmos() and
unlock_cmos() in arch/x86/include/asm/mach_traps.h is potentially
problematic :

  arch/x86/include/asm/mach_traps.h:32:15: warning: suggest braces around empty body in an ¡else¢ statement [-Wempty-body]
  arch/x86/include/asm/mach_traps.h:40:16: warning: suggest braces around empty body in an ¡else¢ statement [-Wempty-body]

Let's just use the standard 'do {} while (0)' solution. That shuts up
gcc and also prevents future problems if the macros should end up
being used in a similar situation elsewhere.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/x86/include/asm/mc146818rtc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index 01fdf56..3bb1b14 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -81,8 +81,8 @@ static inline unsigned char current_lock_cmos_reg(void)
 #else
 #define lock_cmos_prefix(reg) do {} while (0)
 #define lock_cmos_suffix(reg) do {} while (0)
-#define lock_cmos(reg)
-#define unlock_cmos()
+#define lock_cmos(reg) do {} while (0)
+#define unlock_cmos() do {} while (0)
 #define do_i_have_lock_cmos() 0
 #define current_lock_cmos_reg() 0
 #endif
-- 
1.7.8

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-47864580-1324166731=:21784--
