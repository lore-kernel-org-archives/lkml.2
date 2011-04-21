Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1DUIGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:06:55 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:24816
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700Ab1DUIGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:06:46 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 21 Apr 2011 16:10:39 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linaro-dev@lists.linaro.org>,
        <sameo@linux.intel.com>, <patches@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] mmc: sdhci: eliminate sdhci_of_host and sdhci_of_data
Message-ID: <20110421081038.GE4024@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-3-git-send-email-shawn.guo@linaro.org>
 <20110419102053.GC4164@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419102053.GC4164@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:20:53PM +0200, Wolfram Sang wrote:
> On Fri, Mar 25, 2011 at 04:48:48PM +0800, Shawn Guo wrote:
> > The patch is to migrate the use of sdhci_of_host and sdhci_of_data
> > to sdhci_pltfm_host and sdhci_pltfm_data, so that the former pair can
> > be eliminated.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> 
> [...]
> 
> > diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
> > index a3e4be0..12afe86 100644
> > --- a/drivers/mmc/host/sdhci-pltfm.h
> > +++ b/drivers/mmc/host/sdhci-pltfm.h
> > @@ -19,6 +19,10 @@
> >  struct sdhci_pltfm_host {
> >  	struct clk *clk;
> >  	u32 scratchpad; /* to handle quirks across io-accessor calls */
> > +
> > +	/* migrate from sdhci_of_host */
> > +	unsigned int clock;
> > +	u16 xfer_mode_shadow;
> 
> xfer_mode_shadow can be merged into scratchpad. They both fix the same
> issue.
> 
Yeah.

-- 
Regards,
Shawn

