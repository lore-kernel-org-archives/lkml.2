Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1IUUIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:08:36 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:51301 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1IUUIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:08:34 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E7A4413.5000307@am.sony.com>
Date: Wed, 21 Sep 2011 13:07:47 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kdb: Add message about CONFIG_DEBUG_RODATA on failure to
 install breakpoint
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, if CONFIG_DEBUG_RODATA is set, one cannot set breakpoints
via KDB.  Apparently this is a well-known problem, as at least one distribution
now ships with both KDB enabled and CONFIG_DEBUG_RODATA=y for security reasons.

This patch just adds an extra printk message to the breakpoint failure case,
in order to provide some useful diagnostics to the user.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 kernel/debug/kdb/kdb_bp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 20059ef..f015e79 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -153,6 +153,10 @@ static int _kdb_bp_install(struct pt_regs *regs, kdb_bp_t *bp)
 	} else {
 		kdb_printf("%s: failed to set breakpoint at 0x%lx\n",
 			   __func__, bp->bp_addr);
+#ifdef CONFIG_DEBUG_RODATA
+		kdb_printf("May need to disable CONFIG_DEBUG_RODATA in order"
+			" to set breakpoints\n");
+#endif
 		return 1;
 	}
 	return 0;
-- 
1.6.6


