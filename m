Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671Ab2C3VyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:54:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965671Ab2C3VT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:26 -0400
Message-Id: <20120330194834.569873117@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Gordeev <agordeev@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [ 054/175] genirq: Fix incorrect check for forced IRQ thread handler
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@redhat.com>

commit 540b60e24f3f4781d80e47122f0c4486a03375b8 upstream.

We do not want a bitwise AND between boolean operands

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20120309135912.GA2114@dhcp-26-207.brq.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -773,7 +773,7 @@ static int irq_thread(void *data)
 			struct irqaction *action);
 	int wake;
 
-	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
 	else


