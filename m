Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2BAV1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:27:12 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57579 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488Ab2BAVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:26 -0500
X-Sasl-enc: oOIiiPoAelbTwMbk6BvN2rU00pjxE8i36YrQ/3QGUcrx 1328131165
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.830003384@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [33/89] ARM: at91: fix at91rm9200 soc subtype handling
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 3e90772f76010c315474bde59eaca7cc4c94d645 upstream.

Currently setting it to PQFP changes subtype to BGA as subtypes are
swapped in at91rm9200_set_type().

Wrong subtype causes GPIO bank D not to work at all.

After this fix, subtype is still set as unknown. But board code should
fill it in with proper value. Another information is thus printed.

Bug discovery and first implementation made by Veli-Pekka Peltola.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/setup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -27,9 +27,12 @@ EXPORT_SYMBOL(at91_soc_initdata);
 void __init at91rm9200_set_type(int type)
 {
 	if (type == ARCH_REVISON_9200_PQFP)
-		at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
-	else
 		at91_soc_initdata.subtype = AT91_SOC_RM9200_PQFP;
+	else
+		at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
+
+	pr_info("AT91: filled in soc subtype: %s\n",
+		at91_get_soc_subtype(&at91_soc_initdata));
 }
 
 void __init at91_init_irq_default(void)


