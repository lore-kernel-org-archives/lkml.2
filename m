Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2KHVFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:05:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab2KHVCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:11 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 01/11] cris: move usec/nsec conversion to do_slow_gettimeoffset
Date: Thu,  8 Nov 2012 14:01:46 -0700
Message-Id: <1352408516-21988-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Move usec to nsec conversion from arch_gettimeoffset() to
do_slow_gettimeoffset(); in a future patch, do_slow_gettimeoffset()
will be used directly as the implementation of arch_gettimeoffset(),
so needs to perform all required calculations.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/cris/arch-v10/kernel/time.c |    4 ++--
 arch/cris/kernel/time.c          |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index bcffcb6..162892f 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -65,8 +65,8 @@ unsigned long do_slow_gettimeoffset(void)
 	 */
 	count = *R_TIMER0_DATA;
 
-	/* Convert timer value to usec */
-	return (TIMER0_DIV - count) * ((NSEC_PER_SEC/1000)/HZ)/TIMER0_DIV;
+	/* Convert timer value to nsec */
+	return (TIMER0_DIV - count) * (NSEC_PER_SEC/HZ)/TIMER0_DIV;
 }
 
 /* Excerpt from the Etrax100 HSDD about the built-in watchdog:
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index 277ffc4..b063c92 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -46,7 +46,7 @@ static unsigned long (*do_gettimeoffset)(void) = do_slow_gettimeoffset;
 
 u32 arch_gettimeoffset(void)
 {
-       return do_gettimeoffset() * 1000;
+	return do_gettimeoffset();
 }
 #endif
 
-- 
1.7.0.4

