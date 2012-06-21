Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2FUA1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:27:45 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46319 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930Ab2FUA1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:27:44 -0400
Date: Wed, 20 Jun 2012 19:27:42 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
Message-ID: <20120621002742.GL3464@sgi.com>
References: <20120620082457.GE3464@sgi.com>
 <20120620120702.GA3983@srcf.ucam.org>
 <4FE23592.60201@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE23592.60201@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 01:41:54PM -0700, H. Peter Anvin wrote:
> On 06/20/2012 05:07 AM, Matthew Garrett wrote:
> > 
> > No, that's completely wrong. UEFI can't be called in virtual mode until 
> > *after* SetVirtualAddressMap(). The UEFI spec indicates that all 
> > physical memory must have an identity mapping at this stage (section 
> > 2.3.4), so if we don't then that's a bug that needs to be fixed.
> > 
> 
> I think it is a bug, and with the trampoline work in 3.4 we should
> finally have a proper platform to fix it.
> 
> In particular, we should keep a full 1:1 page map around, and it should
> be the one that is in the trampoline (real_mode_header->trampoline_pgd)
> as we need the page directory to be 32-bit addressable.
> 
> The right thing to do is to sync the pgds in the 1:1 area, both for 64
> bit and for legacy 32 bit (PAE 32 bit don't need it, since all the
> kernel maps are shared.)  This is currently done ad hoc (and
> differently!) on both 32 and 64 bits and that really should be fixed.

What do you need from me?  If you want me to help with this, I have a
_WHOLE_ lot of learning to do.  Can you give me any pointers?

We are trying to get this finally fixed.  We have had work-around code
in SLES11 SP1, SLES11 SP2, and RHEL 6.x.  I would love to get this fixed
for future distro snaps.

Thanks,
Robin
