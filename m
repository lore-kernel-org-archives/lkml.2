Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab2EONUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:20:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37489 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab2EONUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:20:15 -0400
Date: Tue, 15 May 2012 14:20:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120515132006.GA26196@srcf.ucam.org>
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB273EB0200007800083D32@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 02:19:07PM +0100, Jan Beulich wrote:

> I would have expected that things work that way, but they
> don't. In particular is the function in efi_64.c that's being
> modified here called from efi_call_phys_{pro,epi}log(), and at
> that point we can't expect virtual addresses to be uniformly
> set yet. So it's a physical call that requires the fixup done
> here, as efi_set_executable() simply expects ->virt_addr to
> be valid. I suspect that no physical calls other than
> phys_efi_set_virtual_address_map() were being done so far
> at all on 64-bit, hiding the problem.

In that case we need to split the mapping code into two chunks and 
configure the memory map earlier. You can't depend on __va() doing 
anything useful on runtime addresses.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
