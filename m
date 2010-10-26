Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab0JZC4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:56:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab0JZC4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 34/43] MN10300: Delete idle_timestamp from irq_cpustat_t
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:56:03 +0100
Message-ID: <20101026025603.23512.98920.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Delete idle_timestamp from irq_cpustat_t as it's an unread relic.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/hardirq.h |    1 -
 arch/mn10300/kernel/process.c      |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)


diff --git a/arch/mn10300/include/asm/hardirq.h b/arch/mn10300/include/asm/hardirq.h
index 54d9501..7bd9b7c 100644
--- a/arch/mn10300/include/asm/hardirq.h
+++ b/arch/mn10300/include/asm/hardirq.h
@@ -19,7 +19,6 @@
 /* assembly code in softirq.h is sensitive to the offsets of these fields */
 typedef struct {
 	unsigned int	__softirq_pending;
-	unsigned long	idle_timestamp;
 	unsigned int	__nmi_count;	/* arch dependent */
 	unsigned int	__irq_count;	/* arch dependent */
 } ____cacheline_aligned irq_cpustat_t;
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index f48373e..243e33c 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -88,8 +88,6 @@ void cpu_idle(void)
 			idle = pm_idle;
 			if (!idle)
 				idle = default_idle;
-
-			irq_stat[cpu].idle_timestamp = jiffies;
 			idle();
 		}
 

