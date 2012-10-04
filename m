Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2JDTXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:23:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60854 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2JDTXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:23:04 -0400
Date: Thu, 4 Oct 2012 20:22:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: rwright@hp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
 on UEFI systems
Message-ID: <20121004192256.GA6521@srcf.ucam.org>
References: <201210032353.q93NrkNi018443@filesys1.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210032353.q93NrkNi018443@filesys1.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 05:53:46PM -0600, Randy Wright wrote:

> The following proposed patch takes advantage of the fact that on EFI
> systems, the memory map provides a better description of the physical
> space than on pre-EFI legacy systems. If the efi_enabled state variable
> indicates the kernel is running on an UEFI system, the patch will use
> information from the UEFI memory map so as not to access addresses that
> should avoided according to the UEFI specification.

This turns out to be awkward. Some (mostly older) EFI platforms still 
only provide the video ROM through the 0xc0000 window, and that's 
sometimes needed even if the platform isn't using int10 for anything 
(for instance, some Intel graphics machines only provide the VBT through 
the video ROM and don't provide that via the PCI BAR). And, of course, 
they have an EFI memory map that just shows a hole there.

So we can't distinguish between the two cases easily. The only thing I 
can think of would be to push that policy out to the graphics drivers 
and have them trigger a scan only if they can't get the required 
information from any other source. I suspect that this patch as is would 
break graphics on a reasonable number of EFI platforms.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
