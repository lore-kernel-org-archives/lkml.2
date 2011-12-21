Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1LUSrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:47:16 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44442 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab1LUSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:47:05 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        sparclinux@vger.kernel.org
Subject: [PATCH 1/2] sparc: Make SA_NOMASK a synonym of SA_NODEFER
Date: Wed, 21 Dec 2011 18:47:00 +0000
Message-Id: <1324493221-4435-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324493221-4435-1-git-send-email-matt@console-pimps.org>
References: <1324493221-4435-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Unlike other architectures, sparc currently has no SA_NODEFER
definition but only the older SA_NOMASK. Since SA_NOMASK is the
historical name for SA_NODEFER, add SA_NODEFER and copy what other
architectures do by making SA_NOMASK a synonym for SA_NODEFER.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/sparc/include/asm/signal.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/signal.h b/arch/sparc/include/asm/signal.h
index e49b828..aa42fe3 100644
--- a/arch/sparc/include/asm/signal.h
+++ b/arch/sparc/include/asm/signal.h
@@ -143,10 +143,11 @@ struct sigstack {
 #define SA_ONSTACK	_SV_SSTACK
 #define SA_RESTART	_SV_INTR
 #define SA_ONESHOT	_SV_RESET
-#define SA_NOMASK	0x20u
+#define SA_NODEFER	0x20u
 #define SA_NOCLDWAIT    0x100u
 #define SA_SIGINFO      0x200u
 
+#define SA_NOMASK	SA_NODEFER
 
 #define SIG_BLOCK          0x01	/* for blocking signals */
 #define SIG_UNBLOCK        0x02	/* for unblocking signals */
-- 
1.7.4.4

