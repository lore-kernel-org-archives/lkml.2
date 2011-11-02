Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab1KBRG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:06:27 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39861 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755305Ab1KBRGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:06:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/NBFafvGi2j26D5dVT8cNw
Date: Wed, 2 Nov 2011 10:06:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Girish K S <girish.shivananjappa@linaro.org>
Subject: [PATCH] mmc: omap_hsmmc: Fix build for hsmmc
Message-ID: <20111102170619.GJ31337@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a3c76eb9d4a1e68a69dd880cf0bcb8a52418b993 (mmc: replace
printk with appropriate display macro) does not compile:

drivers/mmc/host/omap_hsmmc.c: In function 'omap_hsmmc_protect_card':
drivers/mmc/host/omap_hsmmc.c:1273: error: 'pr_info' undeclared (first use in this function)
drivers/mmc/host/omap_hsmmc.c:1273: error: (Each undeclared identifier is reported only once
drivers/mmc/host/omap_hsmmc.c:1273: error: for each function it appears in.)
drivers/mmc/host/omap_hsmmc.c:1273: error: expected ';' before string constant
drivers/mmc/host/omap_hsmmc.c:1275: error: expected statement before ')' token
distcc[15197] ERROR: compile drivers/mmc/host/omap_hsmmc.c on localhost failed

Cc: Girish K S <girish.shivananjappa@linaro.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1270,7 +1270,7 @@ static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
 		}
 	} else {
 		if (!host->protect_card) {
-			pr_info"%s: cover is open, "
+			pr_info("%s: cover is open, "
 					 "card is now inaccessible\n",
 					 mmc_hostname(host->mmc));
 			host->protect_card = 1;
