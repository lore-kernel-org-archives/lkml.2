Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2D0Fki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:40:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18639 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2D0Fkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:40:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 26 Apr 2012 22:40:19 -0700
Date: Fri, 27 Apr 2012 08:40:15 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Message-ID: <20120427084015.cb7c8e00c7d9a4cd01faa5ae@nvidia.com>
In-Reply-To: <20120426215903.GH24211@n2100.arm.linux.org.uk>
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
	<4F99A740.3080407@wwwdotorg.org>
	<20120426215903.GH24211@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 23:59:03 +0200
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Apr 26, 2012 at 01:51:28PM -0600, Stephen Warren wrote:
> > On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> > > The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> > > High-performance Bus (AHB) architecture.
> > > 
> > > The AHB Arbiter controls AHB bus master arbitration. This effectively
> > > forms a second level of arbitration for access to the memory
> > > controller through the AHB Slave Memory device. The AHB pre-fetch
> > > logic can be configured to enhance performance for devices doing
> > > sequential access. Each AHB master is assigned to either the high or
> > > low priority bin. Both Tegra20/30 have this AHB bus.
> > > 
> > > Some of configuration param could be passed from DT too.
> > 
> > I think this code looks reasonable. I'd like to see an ack from Russell,
> > Arnd, and Olof on the final location of the files though.
> 
> Well, the big question which needs answering is whether this AHB software
> interface is something specific to Tegra or whether it really is something
> generic.  There's been some hints in the previous thread that it's
> specific to Tegra, so it may not after all make sense for it to be a
> generic driver.
> 
> However, we _have_ decided "no more drivers under arch/arm".  So I really
> don't want to see "struct xxx_driver" appearing in any code under that
> subdirectory or one of its decendents.  I don't have much more to say
> about location than that.

What about having this driver under "drivers/amba"?

If other similiar drivers are coming up, it's easy to find rather than
having this arch/arm/mach-*. There may be some possibility of
generalization later, then. Also it meets the requirement of no
"struct xxxx_driver" under arch/arm. Arnd?
