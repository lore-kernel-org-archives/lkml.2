Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2DYNBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:01:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13365 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2DYNBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:01:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 25 Apr 2012 06:01:34 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 25 Apr 2012 15:01:28 +0200
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Thread-Topic: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Thread-Index: Ac0i44elZw5fdqENQzCoNlKj29XYIQ==
Message-ID: <20120425.160128.1314575000242024123.hdoyu@nvidia.com>
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com><20120425112519.GB3564@arwen.pp.htv.fi>
In-Reply-To: <20120425112519.GB3564@arwen.pp.htv.fi>
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

From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Date: Wed, 25 Apr 2012 13:25:20 +0200
Message-ID: <20120425112519.GB3564@arwen.pp.htv.fi>

> * PGP Signed by an unknown key
> 
> On Wed, Apr 25, 2012 at 02:07:36PM +0300, Hiroshi DOYU wrote:
> > The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> > High-performance Bus (AHB) architecture.
> >
> > The AHB Arbiter controls AHB bus master arbitration. This effectively
> > forms a second level of arbitration for access to the memory
> > controller through the AHB Slave Memory device. The AHB pre-fetch
> > logic can be configured to enhance performance for devices doing
> > sequential access. Each AHB master is assigned to either the high or
> > low priority bin. Both Tegra20/30 have this AHB bus.
> >
> > Some of configuration param could be passed from DT too.
> >
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > ---
> > v4:
> > Fixed the comments from Felipe/Russell.
> > This is now located under drivers/platform/arm.
> > v3:
> > Use platform_device to get info from dt dynamically.(Felipe/Arnd)
> >
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Just one thing, you seem to have missed Russell's comment about this
> driver being generic. You still add a TEGRA_AHB driver,

For generalization, there seems to be many parts in this driver
depending on SoC implementation, and I'm not so sure how much S/W
compatibility can be kept from H/W spec. Is there any other similar
SoC AHB driver in kernel?

> also, you don't need <mach/iomap.h>. Apart from those, you can add:

Ok, I'll fix and add your Reviewed-by:. Thank you for your review.
