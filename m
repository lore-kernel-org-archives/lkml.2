Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2CNHYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:24:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27507
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab2CNHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:24:12 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz179dN1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 15:26:04 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Marek Vasut <marek.vasut@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Message-ID: <20120314072603.GC8494@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <201203140658.25854.marek.vasut@gmail.com>
 <20120314065512.GB25735@shlinux2.ap.freescale.net>
 <201203140809.22676.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201203140809.22676.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 08:09:22AM +0100, Marek Vasut wrote:
> Dear Dong Aisheng,
> 
> > On Wed, Mar 14, 2012 at 01:58:25PM +0800, Marek Vasut wrote:
> > > Dear Dong Aisheng,
> > > 
> > > > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > ........
> > 
> > > > +static const struct of_device_id mxs_mmc_dt_ids[] = {
> > > > +	{ .compatible = "fsl,imx23-mmc", .data = NULL, },
> > > > +	{ .compatible = "fsl,imx28-mmc", .data = NULL, },
> > > 
> > > Do you really need two distinct ones here?
> > 
> > Hmm, my original purpose is to put soc difference data in .data
> > to remove cpu_is_* function calls in the driver later.
> > Do you think if any issue?
> > 
> 
> Well, what's the difference between the interfaces on mx233 and mx28? Is it 
> something that can't be encoded otherwise? I think they're not so different.
> 
Not much difference except the one register offset and ip version.
See:
#define SSP_VERSION_LATEST      4
#define ssp_is_old()            (host->version < SSP_VERSION_LATEST)
..
#define HW_SSP_VERSION (cpu_is_mx23() ? 0x110 : 0x130)
The ip version can be handled in driver, but for offset...
it depends on cpu_is_* macro.
Putting the HW_SSP_VERSION offset difference in .data can eliminate the need
of cpu_is_*.

Despite of that, since they're two devices,
i guess it's ok to put two compatible string there, right?
Or you thought just put one as below?
{ .compatible = "fsl,mxs-mmc", .data = NULL, },

Regards
Dong Aisheng

