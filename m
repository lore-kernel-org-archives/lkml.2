Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1HOG2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:28:43 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:5585
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596Ab1HOG2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:28:40 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz1432N14e3M98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 15 Aug 2011 14:36:44 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: David Miller <davem@davemloft.net>
CC: <shawn.guo@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
Message-ID: <20110815063643.GI7244@S2100-06.ap.freescale.net>
References: <1313371817-5135-1-git-send-email-shawn.guo@linaro.org>
 <20110814.224341.2228974983062837890.davem@davemloft.net>
 <20110815060708.GH7244@S2100-06.ap.freescale.net>
 <20110814.230529.611834234177280886.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110814.230529.611834234177280886.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 11:05:29PM -0700, David Miller wrote:
> From: Shawn Guo <shawn.guo@freescale.com>
> Date: Mon, 15 Aug 2011 14:07:09 +0800
> 
> > Can you please help me a little bit more with the "other places"?
> 
> arch/sparc/kernel/prom*.c
> 
How about the following changes?  I do not even have a compiler to do
build test for sparc.  Is it possible for me to get one from somewhere?

---8<-----
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 4d87b5d..124280a 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -245,4 +245,11 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
        nextp = &allnodes->allnext;
        allnodes->child = of_pdt_build_tree(allnodes,
                        of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
+
+       /* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
+       of_chosen = of_find_node_by_path("/chosen");
+       if (of_chosen == NULL)
+               of_chosen = of_find_node_by_path("/chosen@0");
+       of_aliases = of_find_node_by_path("/aliases");
+       of_alias_scan(dt_alloc);
 }

-- 
Regards,
Shawn

