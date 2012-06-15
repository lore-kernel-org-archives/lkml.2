Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2FODcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:32:53 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:14307
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436Ab2FODcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:32:52 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2012 23:32:51 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1202hzzz2dh87h2a8h668h839h944hd25he96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 15 Jun 2012 11:17:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>, <mturquette@linaro.org>,
        <sboyd@codeaurora.org>, <skannan@codeaurora.org>,
        <s.hauer@pengutronix.de>, Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v3 1/4] clk: add DT clock binding support
Message-ID: <20120615031747.GG31565@S2101-09.ap.freescale.net>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
 <1339512111-11172-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339512111-11172-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:41:48AM -0500, Rob Herring wrote:
> +struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
> +{
> +	struct of_clk_provider *provider;
> +	struct clk *clk = NULL;

Both clk and clkdev treat NULL as a valid clock and return ERR_PTR for
error case, while all the codes in this patch just return NULL for
error and check (clk != NULL) for valid clock.

Should we force the consistent behavior between DT and non-DT on this?

> +
> +	/* Check if we have such a provider in our array */
> +	mutex_lock(&of_clk_lock);
> +	list_for_each_entry(provider, &of_clk_providers, link) {
> +		if (provider->node == clkspec->np)
> +			clk = provider->get(clkspec, provider->data);
> +		if (clk)
> +			break;
> +	}
> +	mutex_unlock(&of_clk_lock);
> +
> +	return clk;
> +}

-- 
Regards,
Shawn

