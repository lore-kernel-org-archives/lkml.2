Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab1BRONJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:13:09 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:41662 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1BRONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:13:08 -0500
X-IronPort-AV: E=Sophos;i="4.62,187,1297036800"; 
   d="scan'208";a="4398726"
Date: Fri, 18 Feb 2011 14:13:08 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 1/3] pci/xen: Use xen_allocate_pirq_msi
In-Reply-To: <1298038278.16356.3315.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1102181412500.2826@kaball-desktop>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>  <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>  <1297932091.16356.1292.camel@zakaz.uk.xensource.com>  <20110217143003.GE5987@dumpdata.com>  <20110218140729.GA8446@dumpdata.com>
 <1298038278.16356.3315.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Ian Campbell wrote:
> On Fri, 2011-02-18 at 14:07 +0000, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 17, 2011 at 09:30:03AM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Thu, Feb 17, 2011 at 08:41:31AM +0000, Ian Campbell wrote:
> > > > On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > > > > There is no need to use the old interface.
> > > > 
> > > > xen_allocate_pirq -> xen_map_pirq_gsi -> PHYSDEVOP_alloc_irq_vector IFF
> > > > xen_initial_domain() in addition to the kernel side book-keeping side of
> > > > things (set chip and handler, update irq_info etc) whereas
> > > > xen_allocate_pirq_msi just does the kernel book keeping.
> > > > 
> > > > Also xen_allocate_pirq allocates an IRQ in the 1-1 GSI space whereas
> > > > xen_allocate_pirq_msi allocates a dynamic one in the >GSI IRQ space.
> > > 
> > > Which is OK. These are MSIs.
> > > > 
> > > > So this change is actually a semantic change and not just a switch to a
> > > > new interface. I think the change is OK (because the caller is domU
> > > 
> > > Right.
> > > 
> > > > only?) but a comment explaining this would be appreciated.
> > > 
> > > Correct: "domU side".
> > > 
> > > Will fix it up.
> > 
> > How does this look to you?
> > 
> > From eb832bece3131ecbdb509f7f2a9bc53f6692177c Mon Sep 17 00:00:00 2001
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Date: Wed, 16 Feb 2011 13:43:04 -0500
> > Subject: [PATCH 3/5] pci/xen: Use xen_allocate_pirq_msi instead of xen_allocate_pirq
> > 
> > xen_allocate_pirq -> xen_map_pirq_gsi -> PHYSDEVOP_alloc_irq_vector IFF
> > xen_initial_domain() in addition to the kernel side book-keeping side of
> > things (set chip and handler, update irq_info etc) whereas
> > xen_allocate_pirq_msi just does the kernel book keeping.
> > 
> > Also xen_allocate_pirq allocates an IRQ in the 1-1 GSI space whereas
> > xen_allocate_pirq_msi allocates a dynamic one in the >GSI IRQ space.
> > 
> > All of this is uneccessary as this code path is only executed
> > when we run as a domU PV guest with an MSI/MSI-X PCI card passed in.
> > Hence we can jump straight to allocating an dynamic IRQ (and
> > binding it to the proper PIRQ) and skip the rest.
> > 
> > In short: this change is a cosmetic one.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Looks good,
> 
> Reviewed-by: Ian Campbell <ian.campbell@citrix.com>

You can add my reviewed-by too.

