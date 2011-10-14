Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1JNSjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:39:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab1JNSju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:39:50 -0400
Date: Fri, 14 Oct 2011 12:36:33 -0600
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Kai Jiang <Kai.Jiang@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Message-ID: <20111014183633.GA30068@suse.de>
References: <1318521058-15662-1-git-send-email-galak@kernel.crashing.org>
 <20111014183144.GD28556@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014183144.GD28556@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 08:31:45PM +0200, Hans J. Koch wrote:
> On Thu, Oct 13, 2011 at 10:50:58AM -0500, Kumar Gala wrote:
> > From: Kai Jiang <Kai.Jiang@freescale.com>
> > 
> > To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> > extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> > embedded PPC, ARM, and X86 have support for systems with larger physical
> > address than logical.
> > 
> > Since 'addr' may contain a physical, logical, or virtual address the
> > easiest solution is to just change the type to 'phys_addr_t' which
> > should always be greater than or equal to the sizeof(void *) such that
> > it can properly hold any of the address types.
> > 
> > For physical address we can support up to a 44-bit physical address on a
> > typical 32-bit system as we utilize remap_pfn_range() for the mapping of
> > the memory region and pfn's are represnted by shifting the address by
> > the page size (typically 4k).
> > 
> > Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
> > Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
> > Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> 
> Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
> 
> That looks good to me. There's an unnecessary cast (see below), but I fixed that
> on the way.
> 
> Greg, please pull this from branch uio-for-gregkh from
> 
> git://hansjkoch.de/git/linux-hjk

Care to send it as an email?  I can apply it easier that way as I have
limited internet access while on the road.

greg k-h
