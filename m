Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab2DYMPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:15:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58084 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195Ab2DYMP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:15:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Date: Wed, 25 Apr 2012 12:15:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Hiroshi Doyu <hdoyu@nvidia.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com> <20120425083747.466f5c98330af8964d980b8c@nvidia.com> <20120425074639.GB3423@arwen.pp.htv.fi>
In-Reply-To: <20120425074639.GB3423@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204251215.22889.arnd@arndb.de>
X-Provags-ID: V02:K0:mOKb4yJikfAJLvv6nUwdDDw1X4JoW9Q05TQn9ond1S6
 WvRUTtmoA0PKiBU6AH819i5j+x1jGmJHPV+7gJSfGsSbspcUZY
 CaasacqRsTMBWRP7pN8qTYyjPF3hM5cquTDoKgMZFgCst1Ir0P
 Rvoly6bNJ/NZ9iuj44a4dKhz3OTsuqPHyUnIAWjp/FLMApDOkJ
 EaKEk0gKlZ8JKOpWSfRjPiy3yZskB58gTwR1tjXvOi/nsB+y+J
 ZT5EbcsZWMDPFZcSbhaVdujxmQ0PkQqKEUbCa9n7UWhLvy9HmG
 Q+yrblXPXJHdmkh2jhyy8Gd3R2k4mYuEwOVfaO3rV3rFffdfPe
 rskjQxpcyg/86teRb0zk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2012, Felipe Balbi wrote:
>   On Wed, Apr 25, 2012 at 08:37:47AM +0300, Hiroshi Doyu wrote:
> > On Tue, 24 Apr 2012 21:56:45 +0200
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Tue, Apr 24, 2012 at 03:05:14PM +0300, Hiroshi DOYU wrote:
> > > > The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> > > > High-performance Bus (AHB) architecture.
> > > > 
> > > > The AHB Arbiter controls AHB bus master arbitration. This effectively
> > > > forms a second level of arbitration for access to the memory
> > > > controller through the AHB Slave Memory device. The AHB pre-fetch
> > > > logic can be configured to enhance performance for devices doing
> > > > sequential access. Each AHB master is assigned to either the high or
> > > > low priority bin. Both Tegra20/30 have this AHB bus.
> > > > 
> > > > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > > > Cc: Felipe Balbi <balbi@ti.com>
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > ---
> > > > Update:
> > > > - Use platform_device to get info from dt dynamically.(Felipe/Arnd)
> > > > ---
> > > >  arch/arm/mach-tegra/Makefile    |    1 +
> > > >  arch/arm/mach-tegra/tegra-ahb.c |  285 +++++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 286 insertions(+), 0 deletions(-)
> > > 
> > > 1. I thought we weren't going to have any more drivers under
> > >    arch/arm
> > 
> > Can this driver be located under "drivers/misc"? Or is there any better place?
> 
> maybe drivers/platform/arm/ ??

I really wouldn't want to add that directory: It has the risk of letting
people add random crap there that may or may not be related to ARM (the
company) and/or ARM (the architecture).

I think it could go into drivers/amba/ along with the primecell bus driver.
The two drivers are for two different aspects of the AMBA spec and don't
actually depend on one another as far as I can tell, but it's at least
a fitting name, and it doesn't depend on the ARM architecture, which is
important because the driver could be used on other architectures that
are connected to an AHB bus.

	Arnd
