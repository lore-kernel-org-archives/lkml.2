Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1JXNgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:36:39 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:22481
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932501Ab1JXNgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:36:38 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Date: Mon, 24 Oct 2011 21:47:28 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <broonie@opensource.wolfsonmicro.com>, <patches@linaro.org>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024134727.GF1755@S2100-06.ap.freescale.net>
References: <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
 <20111024081706.GC8708@ponder.secretlab.ca>
 <20111024090228.GA1755@S2100-06.ap.freescale.net>
 <4EA52851.8000203@ti.com>
 <20111024091158.GB1755@S2100-06.ap.freescale.net>
 <4EA52C56.3080908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EA52C56.3080908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:43:58PM +0530, Rajendra Nayak wrote:
> Case 2:
> One device for all regulators:
> 
> DT nodes look something like this
> 
> regulators {
> 	reg1: reg@1 {
> 			...
> 			...
> 	};
> 
> 	reg2: reg@2 {
> 			...
> 			...
> 	};
> };
> 
> The regulator driver probes only one device and the dev->of_node
> points to the "regulators" node above.

The mc13892 example I put in the reply to Grant demonstrates that
for some case, dev->of_node is NULL (devices are created by mfd core).

> The regulator driver then based on compatible property extracts
> and registers all the child nodes of "regulators" (for ex: reg1, reg2
> above) with each call to regulator_register and passes the child nodes
> as of_node to be associated with the regulator device.
> 
I still think the discovery of all the child nodes of "regulators" does
not necessarily need to be done in regulator driver.  Instead, it can
be done in regulator core.

-- 
Regards,
Shawn

