Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab0JVTKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:10:01 -0400
Received: from kroah.org ([198.145.64.141]:34199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759339Ab0JVS4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:32 2010
Message-Id: <20101022185232.195843808@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [054/103] mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit c9d66d3515bbb0ad8062721487de7ade02d2b936 upstream.

The driver was originally tested with an additional patch which
made this unneeded but that patch had issuges and got lost on the
way to mainline, causing problems when the errors are reported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/wm831x-irq.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -394,8 +394,13 @@ static int wm831x_irq_set_type(unsigned
 
 	irq = irq - wm831x->irq_base;
 
-	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11)
-		return -EINVAL;
+	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
+		/* Ignore internal-only IRQs */
+		if (irq >= 0 && irq < WM831X_NUM_IRQS)
+			return 0;
+		else
+			return -EINVAL;
+	}
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:


