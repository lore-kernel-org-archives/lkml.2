Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1JRXeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:34:23 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:57528
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007Ab1JRXeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:34:22 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E9E0CEA.6030102@am.sony.com>
Date: Tue, 18 Oct 2011 16:34:02 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ARM 4Kstacks: Decrease poll and select stack usage, when
 using 4K stacks
References: <4E9E0B71.9020708@am.sony.com>
In-Reply-To: <4E9E0B71.9020708@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the max allowed size for struct poll_wqueue to avoid
using too much stack space in do_select() and do_sys_poll(),
when the kernel is using 4K stacks.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 include/linux/poll.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/poll.h b/include/linux/poll.h
index cf40010..b7153a3 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -16,7 +16,11 @@
 extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
+#ifndef CONFIG_4KSTACKS
 #define MAX_STACK_ALLOC 832
+#else
+#define MAX_STACK_ALLOC 448
+#endif
 #define FRONTEND_STACK_ALLOC	256
 #define SELECT_STACK_ALLOC	FRONTEND_STACK_ALLOC
 #define POLL_STACK_ALLOC	FRONTEND_STACK_ALLOC
-- 
1.6.6

