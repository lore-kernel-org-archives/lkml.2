Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1FCNeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:34:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44837 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1FCNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:33:59 -0400
Date: Fri, 3 Jun 2011 14:33:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jim Bos <jim876@xs4all.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110603133351.GA25130@srcf.ucam.org>
References: <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
 <4CE17098.8090000@xs4all.nl>
 <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl>
 <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
 <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
 <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
 <4CE1968D.3050706@xs4all.nl>
 <4DE8DC16.6030308@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE8DC16.6030308@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 03:05:26PM +0200, Jim Bos wrote:
> 
> *,
> 
> Just applied 2.6.39.1 but my system: 64-bit SLackware, 8GB RAM, MSI mobo
> P67A-C45 bios V1.9. previously happily booting via EFI (nice to see
> Linux and the other OS actually NOT overwriting each others boot
> loaders!) immediately re-booted just after loading the kernel.
> 
> Not even a single message is making it on the console, almost immediate
> system reset.  As I noticed there are several EFI related patches, I
> first tried to backout the change to setup.c but that didn't help so
> backing out all the efi changes in the 2.6.39.1 patch, i.e. the files:
>  - arch/x86/kernel/setup.c
>  - arch/x86/platform/efi/efi.c
>  - arch/x86/platform/efi/efi_64.c
> and sure enough system is booting on 2.6.39.1 with these changes removed.

Can you try just reverting

"x86, efi: Retain boot service code until after switching to virtual mode"

? You've got 143 boot services/code regions, which is more than I'd 
tested against, so I'm unsure whether we're overflowing something here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
