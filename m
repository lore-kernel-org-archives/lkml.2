Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1HOGjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:39:15 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21647 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1HOGjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:39:14 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 15 Aug 2011 14:47:20 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: David Miller <davem@davemloft.net>
CC: <shawn.guo@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
Message-ID: <20110815064719.GK7244@S2100-06.ap.freescale.net>
References: <20110815060708.GH7244@S2100-06.ap.freescale.net>
 <20110814.230529.611834234177280886.davem@davemloft.net>
 <20110815063643.GI7244@S2100-06.ap.freescale.net>
 <20110814.233559.1395275660949133114.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110814.233559.1395275660949133114.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 11:35:59PM -0700, David Miller wrote:
> From: Shawn Guo <shawn.guo@freescale.com>
> Date: Mon, 15 Aug 2011 14:36:44 +0800
> 
> > @@ -245,4 +245,11 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
> >         nextp = &allnodes->allnext;
> >         allnodes->child = of_pdt_build_tree(allnodes,
> >                         of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
> > +
> > +       /* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
> > +       of_chosen = of_find_node_by_path("/chosen");
> > +       if (of_chosen == NULL)
> > +               of_chosen = of_find_node_by_path("/chosen@0");
> > +       of_aliases = of_find_node_by_path("/aliases");
> > +       of_alias_scan(dt_alloc);
> >  }
> 
> There is no dt_alloc variable visible in this function.
> 
> I didn't need to use a compiler to find this problem, and neither
> do you.
> 
I should have found that before sending it even for comment.  Yeah,
you beat me to that!

-- 
Regards,
Shawn

