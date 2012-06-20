Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2FTMHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:07:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48386 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2FTMHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:07:07 -0400
Date: Wed, 20 Jun 2012 13:07:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
Message-ID: <20120620120702.GA3983@srcf.ucam.org>
References: <20120620082457.GE3464@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620082457.GE3464@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 03:24:57AM -0500, Robin Holt wrote:
> The kernel allocated memmap may end up being beyond the first
> 512GB of memory.  That early range is identity mapped, while the
> remainder of memory is not.  The net result is the memmap allocated by
> efi_enter_virtual_mode will not be accessible via its __pa as is currently
> passed back to EFI.
> 
> Since EFI is going to have to parse the passed in table, I believe the
> EFI documentation is wrong.
> 
> I asked one of our BIOS engineers to look at the Intel reference code
> and he said it was obvious that the address would have to be a virtaully
> accessible address as we are in virtual mode while EFI is handling the
> callback.

No, that's completely wrong. UEFI can't be called in virtual mode until 
*after* SetVirtualAddressMap(). The UEFI spec indicates that all 
physical memory must have an identity mapping at this stage (section 
2.3.4), so if we don't then that's a bug that needs to be fixed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
