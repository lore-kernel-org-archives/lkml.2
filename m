Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030445Ab2CITq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:46:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030420Ab2CITqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:21 -0500
Message-Id: <20120309190203.003579085@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Stigge <stigge@antcom.de>
Subject: [ 08/95] ARM: LPC32xx: irq.c: Clear latched event
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit 94ed7830cba4dce57b18a2926b5d826bfd184bd6 upstream.

This patch fixes the wakeup disable function by clearing latched events.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-lpc32xx/irq.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-lpc32xx/irq.c
+++ b/arch/arm/mach-lpc32xx/irq.c
@@ -305,9 +305,18 @@ static int lpc32xx_irq_wake(struct irq_d
 
 		if (state)
 			eventreg |= lpc32xx_events[d->irq].mask;
-		else
+		else {
 			eventreg &= ~lpc32xx_events[d->irq].mask;
 
+			/*
+			 * When disabling the wakeup, clear the latched
+			 * event
+			 */
+			__raw_writel(lpc32xx_events[d->irq].mask,
+				lpc32xx_events[d->irq].
+				event_group->rawstat_reg);
+		}
+
 		__raw_writel(eventreg,
 			lpc32xx_events[d->irq].event_group->enab_reg);
 


