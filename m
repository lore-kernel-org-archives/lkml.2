Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1FCO0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:26:34 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4967 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab1FCO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:26:33 -0400
Message-ID: <4DE8EF13.9030609@xs4all.nl>
Date: Fri, 03 Jun 2011 16:26:27 +0200
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110429 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com> <4CE17C4B.1070305@xs4all.nl> <20101115185848.GI2583@sunsite.ms.mff.cuni.cz> <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org>
In-Reply-To: <20110603133351.GA25130@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 03:33 PM, Matthew Garrett wrote:
> On Fri, Jun 03, 2011 at 03:05:26PM +0200, Jim Bos wrote:
>>
>> *,
>>
>> Just applied 2.6.39.1 but my system: 64-bit SLackware, 8GB RAM, MSI mobo
>> P67A-C45 bios V1.9. previously happily booting via EFI (nice to see
>> Linux and the other OS actually NOT overwriting each others boot
>> loaders!) immediately re-booted just after loading the kernel.
>>
>> Not even a single message is making it on the console, almost immediate
>> system reset.  As I noticed there are several EFI related patches, I
>> first tried to backout the change to setup.c but that didn't help so
>> backing out all the efi changes in the 2.6.39.1 patch, i.e. the files:
>>  - arch/x86/kernel/setup.c
>>  - arch/x86/platform/efi/efi.c
>>  - arch/x86/platform/efi/efi_64.c
>> and sure enough system is booting on 2.6.39.1 with these changes removed.
> 
> Can you try just reverting
> 
> "x86, efi: Retain boot service code until after switching to virtual mode"
> 
> ? You've got 143 boot services/code regions, which is more than I'd 
> tested against, so I'm unsure whether we're overflowing something here.
> 

That's seems to be the only EFI patch in 2.6.39.1 and I effectively
removed by =not= applying (skipping) the parts of the 2.6.39.1 patch to
above 3 files.
So yes removing "x86, efi: Retain boot service code until after
switching to virtual mode" indeed fixes the problem for me.

Jim
