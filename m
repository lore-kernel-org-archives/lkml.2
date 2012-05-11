Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2EKGRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:17:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16034 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2EKGRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:17:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 10 May 2012 23:16:59 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "aneesh@ti.com" <aneesh@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 11 May 2012 08:16:55 +0200
Subject: Re: [PATCH 3/4] ARM: tegra30: Add Tegra Memory Controller(MC) driver
Thread-Topic: [PATCH 3/4] ARM: tegra30: Add Tegra Memory Controller(MC)
 driver
Thread-Index: Ac0vPars5f0RyuuyRmiFreZoTA8s8w==
Message-ID: <20120511.091655.1764445721704382888.hdoyu@nvidia.com>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com><1336635764-30597-3-git-send-email-hdoyu@nvidia.com><20120510214604.GA3525@kroah.com>
In-Reply-To: <20120510214604.GA3525@kroah.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/4] ARM: tegra30: Add Tegra Memory Controller(MC) driver
Date: Thu, 10 May 2012 23:46:04 +0200
Message-ID: <20120510214604.GA3525@kroah.com>

> On Thu, May 10, 2012 at 10:42:32AM +0300, Hiroshi DOYU wrote:
> > Tegra Memory Controller(MC) driver for Tegra30
> > Added to support MC General interrupts, mainly for IOMMU(SMMU).
> 
> I'll apply this, but:

Thanks.

> > +static inline u32 mc_readl(struct tegra30_mc *mc, u32 offs)
> > +{
> > +	if (offs < 0x10)
> > +		return readl(mc->regs[0] + offs);
> > +	BUG_ON(offs < 0x3c);
> > +	if (offs < 0x1f0)
> > +		return readl(mc->regs[1] + offs - 0x3c);
> > +	BUG_ON(offs < 0x200);
> > +	if (offs < 0x228)
> > +		return readl(mc->regs[2] + offs - 0x200);
> > +	BUG_ON(offs < 0x284);
> > +	if (offs < 0x400)
> > +		return readl(mc->regs[3] + offs - 0x284);
> > +	BUG();
> > +}
> 
> That's a lot of BUG* calls.  Same thing with the 1/4 patch in this
> series.
> 
> We really should not have a BUG call in any driver, as you just stopped
> the whole system.  I can understand this being there for debugging when
> you create the code originally, but as these are things no one should
> ever be able to hit now, you should remove them, right?
> 
> Care to write a follow-on patch removing all of these BUG_ON and BUG
> calls in this and the drivers/memory/tegra20-mc.c driver?

Ok, they are replying to this email.
