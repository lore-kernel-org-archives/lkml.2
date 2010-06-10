Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab0FJUyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:54:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1621 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0FJUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:54:42 -0400
X-SpamScore: -1
X-BigFish: VPS-1(z5edIzzz1202hzzz2fh2a8h62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4C1150F2.7020807@am.sony.com>
Date: Thu, 10 Jun 2010 13:54:10 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>,
       Bruno Premont <bonbons@linux-vserver.org>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [patch] genirq: update comments related to buslock support
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update comments to match code change in 70aedd24

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 kernel/irq/manage.c |    7 	5 +	2 -	0 !
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/kernel/irq/manage.c
===================================================================
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -236,7 +236,8 @@ void __disable_irq(struct irq_desc *desc
  *	Unlike disable_irq(), this function does not ensure existing
  *	instances of the IRQ handler have completed before returning.
  *
- *	This function may be called from IRQ context.
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
  */
 void disable_irq_nosync(unsigned int irq)
 {
@@ -264,7 +265,9 @@ EXPORT_SYMBOL(disable_irq_nosync);
  *	to complete before returning. If you use this function while
  *	holding a resource the IRQ handler may need you will deadlock.
  *
- *	This function may be called - with care - from IRQ context.
+ *	This function may be called - with care - from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
+ *	See synchronize_irq() comments for explanation of "with care".
  */
 void disable_irq(unsigned int irq)
 {

