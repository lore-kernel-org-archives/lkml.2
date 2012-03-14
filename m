Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2CNFlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:41:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2CNFlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:41:06 -0400
Date: Wed, 14 Mar 2012 13:41:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dong Aisheng <b29396@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de,
        rob.herring@calxeda.com, cjb@laptop.org, rdunlap@xenotime.net,
        vinod.koul@linux.intel.com
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120314054116.GD21337@S2101-09.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <20120313172351.97C5E3E053B@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313172351.97C5E3E053B@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:23:51AM -0600, Grant Likely wrote:
...
> > +	apb@80000000 {
> > +		compatible = "simple-bus";
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +		reg = <0x80000000 0x80000>;
> > +		ranges;
> > +
> > +		apbh@80000000 {
> > +			compatible = "simple-bus";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			reg = <0x80000000 0x3c900>;
> > +			ranges;
> > +
> > +			icoll: interrupt-controller@80000000 {
> > +				compatible = "fsl,imx28-icoll";
> > +				interrupt-controller;
> > +				#interrupt-cells = <1>;
> > +				reg = <0x80000000 0x2000>;
> > +			};
> > +		};
> > +
> > +		apbx@80040000 {
> > +			compatible = "simple-bus";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			reg = <0x80040000 0x40000>;
> > +			ranges;
> > +
> > +			uart1: uart@80074000 {
> > +				compatible = "arm,pl011", "arm,primecell";
> > +				reg = <0x80074000 0x2000>;
> > +				interrupts = <47>;
> > +			};
> > +		};
> 
> What is the purpose of the apbh and apbx busses?  Will more device nodes
> get added to them later, or does each only contain a single device?
> 
Since our ultimate goal is to convert mach-mxs over to device tree,
I would also suggest we have all the hardware blocks defined in dts
from the beginning.

-- 
Regards,
Shawn
