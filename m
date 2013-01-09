Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3AIXSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:18:23 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:52482 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab3AIXSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:18:22 -0500
Date: Wed, 9 Jan 2013 16:17:58 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130109231758.GA27065@obsidianresearch.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <201301092119.57067.arnd@arndb.de>
 <20130109215428.GA13648@avionic-0098.adnet.avionic-design.de>
 <201301092210.49452.arnd@arndb.de>
 <50EDF95F.4070209@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EDF95F.4070209@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 04:12:31PM -0700, Stephen Warren wrote:
> On 01/09/2013 03:10 PM, Arnd Bergmann wrote:
> > On Wednesday 09 January 2013, Thierry Reding wrote:
> >> What happens on Tegra is that we need to map 256 MiB of physical memory
> >> to access all the PCIe extended configuration space. However, ioremap()
> >> on such a large region fails if not enough vmalloc() space is available.
> >>
> >> This was observed when somebody tested this on CardHu which has a 1 GiB
> >> of RAM and therefore remapping the full 256 MiB fails.
> ...
> > Have you checked if the hardware supports an alternative config
> > space access mechanism that does not depend on a huge address range?
> > A lot of them provide an index/data register pair somewhere, as the
> > original PC implementation did.
> 
> That would be nice, but I've talked to the HW engineers, and there's no
> indication that any alternative mechanism exists.

It seems to be convention that extended config space is often only
accessible through mmio space, that was true on x86 last I checked
too..

You could decrease the size of the mapping to only span the bus
numbers that are configured for use via DT.

Are there any concerns about these config registers being accessed
from a context where a new mapping can't be made? Interrupt? Machine
Check? PCI-E Advanced Error Reporting?

Cheers,
Jason
