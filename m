Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab0HDACL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:02:11 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:51277
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757873Ab0HDACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:02:07 -0400
X-SpamScore: -1
X-BigFish: VPS-1(z5edIzzz1202hzzz2fh2a8h62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4C58ADF4.8070201@am.sony.com>
Date: Tue, 3 Aug 2010 17:01:56 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: peterz@infradead.org, peter.p.waskiewicz.jr@intel.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] genirq: update comments related to buslock support
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

