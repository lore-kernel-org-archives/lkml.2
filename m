Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2DYP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:59:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33379 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab2DYP7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:59:45 -0400
Message-ID: <4F981F6C.2050807@wwwdotorg.org>
Date: Wed, 25 Apr 2012 09:59:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: balbi@ti.com, Hiroshi Doyu <hdoyu@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com> <20120425083747.466f5c98330af8964d980b8c@nvidia.com> <20120425074639.GB3423@arwen.pp.htv.fi> <201204251215.22889.arnd@arndb.de>
In-Reply-To: <201204251215.22889.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 06:15 AM, Arnd Bergmann wrote:
> On Wednesday 25 April 2012, Felipe Balbi wrote:
...
>>> Can this driver be located under "drivers/misc"? Or is there any better place?
>>
>> maybe drivers/platform/arm/ ??
> 
> I really wouldn't want to add that directory: It has the risk of letting
> people add random crap there that may or may not be related to ARM (the
> company) and/or ARM (the architecture).
> 
> I think it could go into drivers/amba/ along with the primecell bus driver.
> The two drivers are for two different aspects of the AMBA spec and don't
> actually depend on one another as far as I can tell, but it's at least
> a fitting name, and it doesn't depend on the ARM architecture, which is
> important because the driver could be used on other architectures that
> are connected to an AHB bus.

Hiroshi, is this driver for something (registers/features) that AMBA
actually specifies? AHB might be part of AMBA (I'm not familiar enough
to know), but I don't think this aspect of Tegra's AHB bus is part of
any core AHB/AMBA specification, rather than being some Tegra-specific
control over the bus (given that the registers and bits correspond to
Tegra-specific devices on the bus).

I'm not really convinced that low-level platform-specific drivers like
this shouldn't be in the arch/arm/mach-* directories.
