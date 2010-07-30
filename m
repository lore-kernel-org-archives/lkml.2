Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab0G3SRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:17:47 -0400
Received: from kroah.org ([198.145.64.141]:58873 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000Ab0G3R4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:45 2010
Message-Id: <20100730175145.806184654@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [130/205] USB: musb_core: make disconnect and suspend interrupts work again
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 7d9645fdca444d53907b22a4b73e3967efe09781 upstream.

Commit 1c25fda4a09e8229800979986ef399401053b46e (usb: musb: handle irqs in the
order dictated by programming guide) forgot to get rid of the old 'STAGE0_MASK'
filter for calling musb_stage0_irq(), so now disconnect and suspend interrupts
are effectively ignored...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Acked-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -371,10 +371,6 @@ void musb_hnp_stop(struct musb *musb)
  * @param power
  */
 
-#define STAGE0_MASK (MUSB_INTR_RESUME | MUSB_INTR_SESSREQ \
-		| MUSB_INTR_VBUSERROR | MUSB_INTR_CONNECT \
-		| MUSB_INTR_RESET)
-
 static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				u8 devctl, u8 power)
 {
@@ -1520,7 +1516,7 @@ irqreturn_t musb_interrupt(struct musb *
 	/* the core can interrupt us for multiple reasons; docs have
 	 * a generic interrupt flowchart to follow
 	 */
-	if (musb->int_usb & STAGE0_MASK)
+	if (musb->int_usb)
 		retval |= musb_stage0_irq(musb, musb->int_usb,
 				devctl, power);
 


