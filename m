Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2CNLR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:17:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50059 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2CNLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:17:23 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Date: Wed, 14 Mar 2012 12:17:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Dong Aisheng-B29396" <B29396@freescale.com>,
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
        "Guo Shawn-R65073" <r65073@freescale.com>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <201203140809.22676.marek.vasut@gmail.com> <20120314072603.GC8494@shlinux2.ap.freescale.net>
In-Reply-To: <20120314072603.GC8494@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203141217.19842.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dong Aisheng,

> On Wed, Mar 14, 2012 at 08:09:22AM +0100, Marek Vasut wrote:
> > Dear Dong Aisheng,
> > 
> > > On Wed, Mar 14, 2012 at 01:58:25PM +0800, Marek Vasut wrote:
> > > > Dear Dong Aisheng,
> > > > 
> > > > > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > 
> > > ........
> > > 
> > > > > +static const struct of_device_id mxs_mmc_dt_ids[] = {
> > > > > +	{ .compatible = "fsl,imx23-mmc", .data = NULL, },
> > > > > +	{ .compatible = "fsl,imx28-mmc", .data = NULL, },
> > > > 
> > > > Do you really need two distinct ones here?
> > > 
> > > Hmm, my original purpose is to put soc difference data in .data
> > > to remove cpu_is_* function calls in the driver later.
> > > Do you think if any issue?
> > 
> > Well, what's the difference between the interfaces on mx233 and mx28? Is
> > it something that can't be encoded otherwise? I think they're not so
> > different.
> 
> Not much difference except the one register offset and ip version.
> See:
> #define SSP_VERSION_LATEST      4
> #define ssp_is_old()            (host->version < SSP_VERSION_LATEST)
> ..
> #define HW_SSP_VERSION (cpu_is_mx23() ? 0x110 : 0x130)
> The ip version can be handled in driver, but for offset...
> it depends on cpu_is_* macro.
> Putting the HW_SSP_VERSION offset difference in .data can eliminate the
> need of cpu_is_*.
> 
> Despite of that, since they're two devices,
> i guess it's ok to put two compatible string there, right?
> Or you thought just put one as below?
> { .compatible = "fsl,mxs-mmc", .data = NULL, },
> 
No, I understand now /wrt the register layout.

Best regards,
Marek Vasut
