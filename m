Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1LIBvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:51:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44498 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1LIBv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:51:26 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX197APixN41UM/uou6eBKfd4
Date: Thu, 8 Dec 2011 17:51:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP1: Set the omap1623 sram size to 16K
Message-ID: <20111209015122.GM31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
 <1322686675-26855-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322686675-26855-1-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're always reprogramming the core clock we must make
sure SRAM works. It seems that neither omap1621 or omap1623
has 256K of SRAM. Set the SRAM size to safe value of 16K.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -141,11 +141,9 @@ static void __init omap_detect_sram(void)
 			omap_sram_size = 0x32000;	/* 200K */
 		else if (cpu_is_omap15xx())
 			omap_sram_size = 0x30000;	/* 192K */
-		else if (cpu_is_omap1610() || cpu_is_omap1621() ||
-		     cpu_is_omap1710())
+		else if (cpu_is_omap1610() || cpu_is_omap1611() ||
+				cpu_is_omap1621() || cpu_is_omap1710())
 			omap_sram_size = 0x4000;	/* 16K */
-		else if (cpu_is_omap1611())
-			omap_sram_size = SZ_256K;
 		else {
 			pr_err("Could not detect SRAM size\n");
 			omap_sram_size = 0x4000;
