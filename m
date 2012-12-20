Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2LTWPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:15:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16437 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTWPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:15:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Dec 2012 14:13:51 -0800
Date: Fri, 21 Dec 2012 00:13:48 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/9] clocksource: tegra: Enable ARM arch_timer with TSC
Message-ID: <20121220221348.GB19766@tbergstrom-lnx.Nvidia.com>
References: <50D305A6.2080904@arm.com>
 <20121220125507.GB6819@tbergstrom-lnx.Nvidia.com>
 <50D31365.9000009@arm.com>
 <20121220.164230.292625215885249791.hdoyu@nvidia.com>
 <50D34630.9020708@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D34630.9020708@arm.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > "tegra114.dtsi" has the folloiwng "tsc" entry. So can we consider that
> > if dts has this entry, CNTFRQ is not set, which implies it's in secure
> > mode. kernel should set it up by itself? Otherwise, skip this setup
> > and use it. For example:
> > 
> >  	tsc {
> >  		compatible = "nvidia,tegra114-tsc";
> >  		reg = <0x700f0000 0x20000>;
> > +		setup-cntfrq;
> >  	};
> > 
> > Is this what you explained in the above?
> > At least, kernel can survive without bootloader/firmware support, ATM.
> 
> No. The DT should only describe the hardware, and not something that is
> Linux specific.
> 
> Just use the "clock-frequency" attribute in the timer arch-timer node,
> and get rid of this CNTFRQ setting. The driver already knows how to deal
> with this situation if this attribute is set.

The frequency is probed at boottime by the kernel though. It will not
necessarily be the same for every board.

Cheers,

Peter.
