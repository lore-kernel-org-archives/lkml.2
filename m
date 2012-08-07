Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2HGIli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:41:38 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:31892
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937Ab2HGIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:41:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH 3/4] cpu: export cpu hotplug disable/enable functions as global functions
Date: Tue, 7 Aug 2012 16:43:25 +0800
Message-ID: <1344329006-10645-3-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq driver of mpc85xx will disable/enable cpu hotplug temporarily.
Therefore, the related functions should be exported.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 include/linux/cpu.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..df8f73d 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -146,6 +146,8 @@ void notify_cpu_starting(unsigned int cpu);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
+extern void cpu_hotplug_disable_before_freeze(void);
+extern void cpu_hotplug_enable_after_thaw(void);
 #else	/* CONFIG_SMP */
 
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
@@ -167,6 +169,8 @@ static inline void cpu_maps_update_done(void)
 {
 }
 
+static inline void cpu_hotplug_disable_before_freeze(void)	{}
+static inline void cpu_hotplug_enable_after_thaw(void)	{}
 #endif /* CONFIG_SMP */
 extern struct bus_type cpu_subsys;
 
-- 
1.6.4.1


