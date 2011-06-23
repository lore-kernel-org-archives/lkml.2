Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab1FWOMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:12:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51785 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab1FWOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:12:39 -0400
Date: Thu, 23 Jun 2011 15:12:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stefan Assmann <sassmann@kpanic.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110623141222.GA30003@srcf.ucam.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
 <20110623133950.GB28333@srcf.ucam.org>
 <4E0348E0.7050808@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0348E0.7050808@kpanic.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 04:08:32PM +0200, Stefan Assmann wrote:
> On 23.06.2011 15:39, Matthew Garrett wrote:
> > Would it be more reasonable to do this in the bootloader? You'd ideally 
> > want this to be done as early as possible in order to avoid awkward 
> > situations like your ramdisk ending up in the bad RAM area.
> 
> Not sure what exactly you are suggesting here. The kernel somehow needs
> to know what memory areas to avoid so we supply this information via
> kernel command line.
> What the bootloader could do is to allow the kernel/initrd to be loaded
> at an alternative address. That's briefly mentioned in the BadRAM
> Documentation as well. Is that what you mean or am I missing something?

For EFI booting we just hand an e820 map to the kernel. It ought to be 
easy enough to add support for that to the 16-bit entry point as well. 
Then the bootloader just needs to construct an e820 map of its own. I 
think grub2 actually already has some support for this. The advantage of 
this approach is that the knowledge of bad memory only has to exist in 
one place (ie, the bootloader) - the kernel can remain blisfully 
unaware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
