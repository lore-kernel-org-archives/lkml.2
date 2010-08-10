Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0HJJLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:11:39 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57992 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241Ab0HJJLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:11:15 -0400
Date: Tue, 10 Aug 2010 11:11:13 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/4] arch/frv: Removing dead HEARTBEAT config option
Message-ID: <fafef93430b45ac966abc77ed061647af2814873.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HEARTBEAT doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/frv/kernel/time.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..e86df6c 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -66,12 +66,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 
 	do_timer(1);
 
-#ifdef CONFIG_HEARTBEAT
-	static unsigned short n;
-	n++;
-	__set_LEDS(n);
-#endif /* CONFIG_HEARTBEAT */
-
 	write_sequnlock(&xtime_lock);
 
 	update_process_times(user_mode(get_irq_regs()));
-- 
1.7.0.4

