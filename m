Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1KOEgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:36:55 -0500
Received: from sous-sol.org ([216.99.217.87]:53284 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751762Ab1KOEgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:36:54 -0500
Date: Mon, 14 Nov 2011 20:36:34 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org
Subject: Re: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
Message-ID: <20111115043634.GA30247@sequoia.sous-sol.org>
References: <4EC19738.8050007@arndnet.de>
 <4EC1B80D.5000102@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC1B80D.5000102@arndnet.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Hannemann (arnd@arndnet.de) wrote:
> Am 14.11.2011 23:33, schrieb Arnd Hannemann:
> > when trying to boot kernel 3.2rc1 on my thinkpad t510 I get an endless loop of errors:
> > 
> >  DRHD: handling fault status reg 2
> >  DMAR: [DMA Read] Request device [0d:00.0] fault addr fffff000
> >  DMAR: [fault reason 02] Present bit in context entry is clear
> > 
> > screenshot can be found here:
> > http://arndnet.de/lkml/screenshot3.2rc1.jpg
> > 
> > kernel 3.1.1 is booting up flawlessly.
> 
> I must have inadvertently enabled CONFIG_INTEL_IOMMU_DEFAULT_ON in my config
> for 3.2-rc1.
> 
> With disabled CONFIG_INTEL_IOMMU_DEFAULT_ON my thinkpad boots up again.
> Not sure if this is expected?

With CONFIG_INTEL_IOMMU_DEFAULT_ON=n, you have to manually enabled the
IOMMU on the kernel commandline.  So, yes, disabling that and having
your laptop boot is not surprising.  The Kconfig item changed names,
and the default is yes, so you may have had CONFIG_DMAR_DEFAULT_ON=n,
but this would not have propagated forward.

As for the endless loop of DMAR faults...sounds like the Ricoh
cardbus/firewire issue where the firewire fucntion does DMA from
function 0.  I thought this was quirked and fixed though.

thanks,
-chris
