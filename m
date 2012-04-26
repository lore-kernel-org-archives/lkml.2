Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab2DZV7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:59:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38145 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab2DZV7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:59:33 -0400
Date: Thu, 26 Apr 2012 22:59:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, swarren@nvidia.com,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Message-ID: <20120426215903.GH24211@n2100.arm.linux.org.uk>
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <4F99A740.3080407@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F99A740.3080407@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 01:51:28PM -0600, Stephen Warren wrote:
> On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
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
> 
> I think this code looks reasonable. I'd like to see an ack from Russell,
> Arnd, and Olof on the final location of the files though.

Well, the big question which needs answering is whether this AHB software
interface is something specific to Tegra or whether it really is something
generic.  There's been some hints in the previous thread that it's
specific to Tegra, so it may not after all make sense for it to be a
generic driver.

However, we _have_ decided "no more drivers under arch/arm".  So I really
don't want to see "struct xxx_driver" appearing in any code under that
subdirectory or one of its decendents.  I don't have much more to say
about location than that.
