Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2BTAMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:12:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BTAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:12:05 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 07/30] compat: Introduce COMPAT_USE_64BIT_TIME
Date: Sun, 19 Feb 2012 16:07:45 -0800
Message-Id: <1329696488-16970-8-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:12:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Allow a compatibility ABI to use a 64-bit time_t and 64-bit members in
struct timeval and struct timespec to avoid the Y2038 problem.

This will be used for the x32 ABI.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/compat.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 41c9f65..1be91c0 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -19,6 +19,10 @@
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
+#ifndef COMPAT_USE_64BIT_TIME
+#define COMPAT_USE_64BIT_TIME 0
+#endif
+
 #define compat_jiffies_to_clock_t(x)	\
 		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
 
-- 
1.7.6.5

