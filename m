Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0LICBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:01:00 -0500
Received: from ozlabs.org ([203.10.76.45]:41076 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0LICA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:00:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: x86@kernel.org
Subject: [PATCH 1/2] lguest: fix crash lguest_time_init
Date: Thu, 9 Dec 2010 12:30:53 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012091230.53907.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fe25c7fc2e "x86: lguest: Convert to new irq chip functions" converted
enable_lguest_irq() to take a struct irq_data *, but didn't fix the one
internal caller.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: x86@kernel.org
---
 arch/x86/lguest/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1002,7 +1002,7 @@ static void lguest_time_init(void)
 	clockevents_register_device(&lguest_clockevent);
 
 	/* Finally, we unblock the timer interrupt. */
-	enable_lguest_irq(0);
+	clear_bit(0, lguest_data.blocked_interrupts);
 }
 
 /*
