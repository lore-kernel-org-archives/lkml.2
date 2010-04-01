Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0DACos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0DACor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:44:47 -0400
Date: Wed, 31 Mar 2010 22:44:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100401024421.GA5877@redhat.com>
References: <20100331152417.GB13406@hmsreliant.think-freely.org> <20100331212535.GR29241@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331212535.GR29241@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:25:35PM -0700, Chris Wright wrote:
> * Neil Horman (nhorman@tuxdriver.com) wrote:
> > Flush iommu during shutdown
> > 
> > When using an iommu, its possible, if a kdump kernel boot follows a primary
> > kernel crash, that dma operations might still be in flight from the previous
> > kernel during the kdump kernel boot.  This can lead to memory corruption,
> > crashes, and other erroneous behavior, specifically I've seen it manifest during
> > a kdump boot as endless iommu error log entries of the form:
> > AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.1 domain=0x000d
> > address=0x000000000245a0c0 flags=0x0070]
> 
> We've already fixed this problem once before, so some code shift must
> have brought it back.  Personally, I prefer to do this on the bringup
> path than the teardown path.  Besides keeping the teardown path as
> simple as possible (goal is to get to kdump kernel asap), there's also
> reason to competely flush on startup in genernal in case BIOS has done
> anything unsavory.

Can we flush domains (all the I/O TLBs assciated with each domain), during
initialization? I think all the domain data built by previous kernel will
be lost and new kernel will have no idea about. 

Thanks
Vivek
