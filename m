Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab0C3Xcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:32:50 -0400
Received: from kroah.org ([198.145.64.141]:46550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab0C3XVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:25 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:36 2010
Message-Id: <20100330224835.781902271@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Meelis Roos <mroos@linux.ee>, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [115/156] qlogicpti: Remove slash in QlogicPTI irq name
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Meelis Roos <mroos@linux.ee>

[ Upstream commit 77d3926306bf4eecac50150ba5625797219f14ba ]

qlogicpti driver registers its irq with a name containing slash.
This results in

[   71.049735] WARNING: at fs/proc/generic.c:316 __xlate_proc_name+0xa8/0xb8()
[   71.132815] name 'Qlogic/PTI'

because proc_mkdir with the name of the irq fails. Fix it by just
removing the slash from irq name. Discovered and tested on real hardware
(Sun Ultra 1).

Signed-off-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qlogicpti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -738,7 +738,7 @@ static int __devinit qpti_register_irq(s
 	 * sanely maintain.
 	 */
 	if (request_irq(qpti->irq, qpti_intr,
-			IRQF_SHARED, "Qlogic/PTI", qpti))
+			IRQF_SHARED, "QlogicPTI", qpti))
 		goto fail;
 
 	printk("qlogicpti%d: IRQ %d ", qpti->qpti_id, qpti->irq);


