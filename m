Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1KGUXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:23:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49480 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab1KGUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:23:52 -0500
Date: Mon, 7 Nov 2011 20:23:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
Message-ID: <20111107202324.GA27515@srcf.ucam.org>
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320680088-2584-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:34:48PM +0000, Matt Fleming wrote:

> After the feedback from v1 I tried to unify the efi_ioremap()
> implementations but ran into the issue detailed in the RH bug report
> in the changelog. Unless we teach the x86 setup code that
> EFI_RUNTIME_SERVICES_DATA regions should be part of the direct kernel
> mapping table (even though they're marked as E820_RESERVED) I think
> this patch makes the most sense.

Honestly it seems like there may well be an argument for that. We're 
talking about executable code that the kernel will be calling - it seems 
theoretically neater for it to be added to the direct mapping. We're 
just heavily constrained by our collapsing of the EFI memory map onto 
the rather less fine-grained E820 one and the lack of any obvious way to 
extend that in an OS-specific manner. I guess we could expect the 
bootloader to conform to the standard and then re-walk the EFI memory 
map ourselves to fix things up, but eww...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
