Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab2BFFWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 00:22:44 -0500
Received: from ozlabs.org ([203.10.76.45]:40479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2BFFWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 00:22:43 -0500
From: Michael Neuling <mikey@neuling.org>
To: Grant Likely <grant.likely@secretlab.ca>
cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 21/25] irqdomain/powerpc: Replace custom xlate functions with library functions
In-reply-to: <1327700179-17454-22-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <1327700179-17454-22-git-send-email-grant.likely@secretlab.ca>
Comments: In-reply-to Grant Likely <grant.likely@secretlab.ca>
   message dated "Fri, 27 Jan 2012 14:36:15 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Mon, 06 Feb 2012 16:22:41 +1100
Message-ID: <24476.1328505761@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static const struct irq_domain_ops pmac_pic_host_ops = {
>  	.match = pmac_pic_host_match,
>  	.map = pmac_pic_host_map,
> -	.xlate = pmac_pic_host_xlate,
> +	.xlate = irq_domain_xlate_onecell;
>  };
>  

This causes a compile fail (in next-20120206):
  arch/powerpc/platforms/powermac/pic.c:294: error: expected '}' before ';' token
Trivial fix below:



irqdomain/powerpc: Fix compile error in powermac/pic.c

Error introduced in:
  commit 72d6b477675374eafd206720d6c9146520df18ce
  Author: Grant Likely <grant.likely@secretlab.ca>
  irqdomain/powerpc: Replace custom xlate functions with library functions

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 3af29d1..92afc38 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -291,7 +291,7 @@ static int pmac_pic_host_map(struct irq_domain *h, unsigned int virq,
 static const struct irq_domain_ops pmac_pic_host_ops = {
 	.match = pmac_pic_host_match,
 	.map = pmac_pic_host_map,
-	.xlate = irq_domain_xlate_onecell;
+	.xlate = irq_domain_xlate_onecell,
 };
 
 static void __init pmac_pic_probe_oldstyle(void)
