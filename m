Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2HQWpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:45:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17714 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab2HQWpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:45:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 17 Aug 2012 15:45:37 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Xin Xie <xxie@nvidia.com>, "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "jhovold@gmail.com" <jhovold@gmail.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 18 Aug 2012 06:45:32 +0800
Subject: RE: [PATCH 1/2] mfd: dt: tps6586x: Add power off control
Thread-Topic: [PATCH 1/2] mfd: dt: tps6586x: Add power off control
Thread-Index: Ac18ZP2I6zQFAWiCRZqwbltvuvCJIwAZKsiA
Message-ID: <A7051F87A141B744BCAF487D48E5B3BDF5BA98283F@HKMAIL02.nvidia.com>
References: <1345194989-11614-1-git-send-email-bilhuang@nvidia.com>
 <1345194989-11614-2-git-send-email-bilhuang@nvidia.com>
 <20120817104150.GA27633@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120817104150.GA27633@avionic-0098.mockup.avionic-design.de>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nvpublic
> On Fri, Aug 17, 2012 at 02:16:28AM -0700, Bill Huang wrote:
> [...]
> > diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> [...]
> > @@ -505,6 +519,11 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
> >  		goto err_add_devs;
> >  	}
> >
> > +	tps6586x_dev = &client->dev;
> > +
> > +	if (pdata->pm_off && !pm_power_off)
> > +		pm_power_off = tps6586x_power_off;
> > +
> 
> I think the assignment of tps6586x_dev needs to go inside the if block as well. Otherwise it might be
> overwritten by another instance for systems that actually have more than one tps6586x. Since currently
> the driver can't be built as a module it probably makes little sense to clean this up in .remove(),
> but it might still be worth adding so it isn't forgotten if and when somebody tries to convert the
> driver to a module.
> 
Thanks, good point.

> I should note that I don't like very much how the pm_power_off works.
> Maybe this should really be changed to allow passing a context for the function to work from.
> Something like:
> 
> 	pm_power_off = tps6586x_power_off;
> 	pm_power_off_data = &client->dev;
> 
> Where pm_power_off() would receive pm_power_off_data as an argument.
> 
> Even that's not very pretty. On the other hand this doesn't really buy us much because only the
> storage location of the variable would change and nothing else. But it would still make the
> association of the data clearer.
> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
