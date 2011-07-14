Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1GNPET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:04:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35419 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab1GNPEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:04:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 4/6] hw_breakpoints: Breakpoints arch ability don't need perf events
Date: Thu, 14 Jul 2011 17:03:55 +0200
Message-Id: <1310655837-328-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The breakpoint support ability in an arch is not related
to the fact perf events is built or not. HAVE_HW_BREAKPOINT
only shows an ability so this dependency makes no sense
anymore. Archs that select HAVE_HW_BREAKPOINT already
ensure that perf event is built.

Remove that dependency.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 arch/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 26b0e23..341ac95 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -146,7 +146,6 @@ config HAVE_DMA_API_DEBUG
 
 config HAVE_HW_BREAKPOINT
 	bool
-	depends on PERF_EVENTS
 
 config HAVE_MIXED_BREAKPOINTS_REGS
 	bool
-- 
1.7.5.4

