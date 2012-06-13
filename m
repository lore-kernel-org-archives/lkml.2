Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2FMOL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:11:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26670 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2FMOL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:11:26 -0400
Date: Wed, 13 Jun 2012 10:04:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86/mm: remove arch-specific PTE/PMD get-and-clear
 functions
Message-ID: <20120613140404.GH5979@phenom.dumpdata.com>
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:20:43AM +0100, David Vrabel wrote:
> This series removes the x86-specific implementation of
> ptep_get_and_clear() and pmdp_get_and_clear().
> 
> The principal reason for this is it allows Xen paravitualized guests
> to batch the PTE clears which is a significant performance
> optimization of munmap() and mremap() -- the number of entries into
> the hypervisor is reduced by about a factor of about 30 (60 in 32-bit
> guests) for munmap().
> 
> There may be minimal gains on native and KVM guests due to the removal
> of the locked xchg.

What about lguest?
> 
> Removal of arch-specific functions where generic ones are suitable
> seems to be a generally useful thing to me.
> 
> The full reasoning for why this is safe is included in the commit
> message of patch 1 but to summarize.  The atomic get-and-clear does
> not guarantee that the latest dirty/accessed bits are returned as TLB
> as there is a still a window after the get-and-clear and before the
> TLB flush that the bits may be updated on other processors.  So, user
> space applications accessing pages that are being unmapped or remapped
> already have unpredictable behaviour.
> 
> David
