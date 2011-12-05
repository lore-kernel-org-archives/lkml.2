Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1LEUdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:33:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:38629 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab1LEUdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:33:40 -0500
Message-ID: <1323117157.660.22.camel@pasglop>
Subject: Re: [PATCH -v2 01/16] PCI: add declaration for pcibios_set_master()
 to pci core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux@arm.linux.org.uk, vapier@gentoo.org, dhowells@redhat.com,
        ysato@users.sourceforge.jp, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org, paulus@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, cmetcalf@tilera.com,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de, mingo@redhat.com,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Tue, 06 Dec 2011 07:32:37 +1100
In-Reply-To: <20111205110639.479a6e8e@jbarnes-desktop>
References: <20111028214726.20088.30551.stgit@amt.stowe>
	 <20111028214735.20088.19168.stgit@amt.stowe>
	 <20111205110639.479a6e8e@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 11:06 -0800, Jesse Barnes wrote:
> On Fri, 28 Oct 2011 15:47:35 -0600
> Myron Stowe <myron.stowe@redhat.com> wrote:
> 
> > From: Myron Stowe <mstowe@redhat.com>
> > 
> > Currently, pcibios_set_master() is implemented in architecture-
> > specific code.  There is nothing architecture-specific about PCI's
> > 'latency timer'.
> > 
> > This patch adds a declaration for pcibios_set_master() to PCI's core
> > in preperation for pulling the function itself up into the core.
> > Without the addition of this declaration, subsequent patches that
> > remove inline definitions of pcibios_set_master() would be removing
> > the only declaration of such.
> > 
> > No functional change.
> > 
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> 
> Ok this series is in -next.  Let's see what breaks this time. :)

On the other hand...

One thing that annoys the sh*it out of me is that I cannot use
pcibios_set_master() to establish the DMA/iommu resources for a device,
because set_dma_mask() will be called -after- set_master(), thus I need
to provision every device with 32-bit DMA resources (which can be quite
scarse) just in case the driver doesn't later call set_dma_mask(64-bit).

If only we could reverse the call order... lots of drivers to fix
unfortunately.

In which case I -would- hook into pcibios_set_master()...

Cheers,
Ben.


