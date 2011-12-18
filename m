Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1LRXv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:51:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LRXvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:51:53 -0500
Date: Sun, 18 Dec 2011 15:51:33 -0800
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-1affc46cffad9f2bc7c9ffec85726446903a58f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jj@chaosbits.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1112180103130.21784@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1112180103130.21784@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Use "do { } while(0)" for empty lock_cmos(
 )/unlock_cmos() macros
Git-Commit-ID: 1affc46cffad9f2bc7c9ffec85726446903a58f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 18 Dec 2011 15:51:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1affc46cffad9f2bc7c9ffec85726446903a58f9
Gitweb:     http://git.kernel.org/tip/1affc46cffad9f2bc7c9ffec85726446903a58f9
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Sun, 18 Dec 2011 01:05:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 18 Dec 2011 09:14:31 +0100

x86: Use "do { } while(0)" for empty lock_cmos()/unlock_cmos() macros

gcc noticed (when using -Wempty-body) that our use of
lock_cmos() and unlock_cmos() in
arch/x86/include/asm/mach_traps.h is potentially problematic :

  arch/x86/include/asm/mach_traps.h:32:15: warning: suggest braces around empty body in an ¡else¢ statement [-Wempty-body]
  arch/x86/include/asm/mach_traps.h:40:16: warning: suggest braces around empty body in an ¡else¢ statement [-Wempty-body]

Let's just use the standard 'do {} while (0)' solution. That
shuts up gcc and also prevents future problems if the macros
should end up being used in a similar situation elsewhere.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1112180103130.21784@swampdragon.chaosbits.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mc146818rtc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index 01fdf56..0e8e85b 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -81,8 +81,8 @@ static inline unsigned char current_lock_cmos_reg(void)
 #else
 #define lock_cmos_prefix(reg) do {} while (0)
 #define lock_cmos_suffix(reg) do {} while (0)
-#define lock_cmos(reg)
-#define unlock_cmos()
+#define lock_cmos(reg) do { } while (0)
+#define unlock_cmos() do { } while (0)
 #define do_i_have_lock_cmos() 0
 #define current_lock_cmos_reg() 0
 #endif
