Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1DRLFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:05:18 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:14292 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1DRLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:05:14 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2fi+F6m3KuVXGm0EAZeTo
Date: Mon, 18 Apr 2011 14:05:08 +0300
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ramesh Gupta <grgupta@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2
 cache
Message-ID: <20110418110502.GI12272@atomide.com>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
 <20110414223036.GA7335@n2100.arm.linux.org.uk>
 <201104180929.33569.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104180929.33569.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [110418 10:26]:
> On Friday 15 April 2011, Russell King - ARM Linux wrote:
> > On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
> > > From: Ramesh Gupta <grgupta@ti.com>
> > > 
> > > This patch is to flush the iommu page table entries from L1 and L2
> > > caches using dma_map_single. This also simplifies the implementation
> > > by removing the functions  flush_iopgd_range/flush_iopte_range.
> > 
> > No.  This usage is just wrong.  If you're going to use the DMA API then
> > unmap it, otherwise the DMA API debugging will go awol.
> 
> 
> It's also completely upside-down: The iommu support should provide interfaces
> using the dma-mapping API, not use that API to provide a machine specific
> version of the generic interface.
> 
> As far as I can tell, nothing actually uses these drivers, maybe we should just
> remove them before we get any code in the mainline kernel that depends on it.

There is drivers/media/video/omap3isp/isp.c. But if we now
have a generic replacement for this code we should start using it.

Hiroshi, any comments on that?

Regards,

Tony
