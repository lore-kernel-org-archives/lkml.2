Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1LGRN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:13:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab1LGQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:16:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:24 2011
Message-Id: <20111207160824.007602831@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:37 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Felipe Balbi <balbi@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [17/80] ARM: OMAP: smartreflex: fix IRQ handling bug
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 5a4f1844c2ba21f804d7729306d9b16eaeb724a8 upstream.

Fix a bug which has been on this driver since
it was added by the original commit 984aa6db
which would never clear IRQSTATUS bits.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/smartreflex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -137,7 +137,7 @@ static irqreturn_t sr_interrupt(int irq,
 		sr_write_reg(sr_info, ERRCONFIG_V1, status);
 	} else if (sr_info->ip_type == SR_TYPE_V2) {
 		/* Read the status bits */
-		sr_read_reg(sr_info, IRQSTATUS);
+		status = sr_read_reg(sr_info, IRQSTATUS);
 
 		/* Clear them by writing back */
 		sr_write_reg(sr_info, IRQSTATUS, status);


