Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab1EXVwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:52:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53763 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab1EXVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JlUFuI/sMZGF62p0t3TiJfQnXUpKQm4w9dmH3APOmhEXZBPNetzW774uCpgXfalMaD
         JLv07fjj8TWQrsc+EUW2r9XrcLUmE7KVP3MrGW7nMt/aEa5Y0zNMDQ6Fj1ogoGN5LXq5
         TajEC7p6HWRsoOlUQ6MTZcySxMjY9IhusFYtU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/6] hw_breakpoints: Breakpoints arch ability don't need perf events
Date: Tue, 24 May 2011 23:52:25 +0200
Message-Id: <1306273947-8410-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index f78c2be..ce4be89 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -149,7 +149,6 @@ config HAVE_DEFAULT_NO_SPIN_MUTEXES
 
 config HAVE_HW_BREAKPOINT
 	bool
-	depends on PERF_EVENTS
 
 config HAVE_MIXED_BREAKPOINTS_REGS
 	bool
-- 
1.7.3.2

