Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1K3OaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:30:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab1K3O37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:29:59 -0500
Date: Wed, 30 Nov 2011 16:31:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Message-ID: <20111130143122.GC21413@redhat.com>
References: <cover.1322592494.git.mst@redhat.com>
 <201111300909.18431.arnd@arndb.de>
 <20111130115956.GA21413@redhat.com>
 <201111301404.41544.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111301404.41544.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 02:04:41PM +0000, Arnd Bergmann wrote:
> On Wednesday 30 November 2011, Michael S. Tsirkin wrote:
> > > > Presumably whoever wrote that architecture considered and discarded setting GENERIC_IOMAP.
> > > 
> > > The tile PCI controller is apparently special in that it does not map the
> > > PIO region into MMIO space, or make it available in any other way, so generic
> > > iomap with IOCOND is pointless. Setting NO_IPORT will still mean that drivers
> > > using ioport_map will not be built. This mostly impacts the legacy (non-AHCI)
> > > ATA controllers, which I assume are not used on tile anyway.
> > 
> > I don't object to setting NO_IPORT at all, but this won't help address
> > the problem this patch is fixing, which is to use a generic pci_iomap
> > on tile.
> 
> Ah, right. I didn't realize that the generic pci_iomap still attempts
> to call ioport_map(). It would probably make sense to enclose
> the ioport_map() call in pci_iomap() inside of #ifdef CONFIG_HAS_IOPORT.
> It's not exactly beautiful, but probably the most correct solution
> so that we can make any call to ioport_map() a build-time error on
> architectures that set CONFIG_NO_IOPORT.
> 
> 	Arnd

I'm not sure why do you want to do that.

-- 
MST
