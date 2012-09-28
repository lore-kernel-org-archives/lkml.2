Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2I1O5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:57:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31412 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350Ab2I1O5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:57:10 -0400
Date: Fri, 28 Sep 2012 11:00:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] iommu/amd: Split device table initialization into
 irq and dma part
Message-ID: <20120928150009.GI7483@localhost.localdomain>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-6-git-send-email-joerg.roedel@amd.com>
 <20120928141752.GD7483@localhost.localdomain>
 <20120928142555.GC4009@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928142555.GC4009@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 04:25:55PM +0200, Joerg Roedel wrote:
> On Fri, Sep 28, 2012 at 10:17:53AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, Sep 28, 2012 at 02:23:55PM +0200, Joerg Roedel wrote:
> > > When the IOMMU is enabled very early (as with irq-remapping)
> > > some devices are still in BIOS hand. When dma is blocked
> > > early this can cause lots of IO_PAGE_FAULTs. So delay the
> > > DMA initialization and do it right before the dma_ops are
> > > initialized.
> > > To be secure, block all interrupts by default when irq-remapping is
> > 
> > What are you trying to be secure against?
> 
> Against attacks of faked MSI msgs that could DoS the system. MSI
> messages are only specific DMA transactions in the end and a guest with
> a device assigned has control over its DMA engine and can thus send
> arbitrary interrupt requests to the host. There is a whole paper about
> such attacks. I can't find right now, but I send you  a link when I find
> it.

I think I know which one you are talking about - that is the Joanna's
Rutkowski/Rafal Wojtczuk paper. Could you include a bit about it
in the description or at least the title in the git commit pls?
