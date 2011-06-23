Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab1FWPiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:38:00 -0400
Received: from app1b.xlhost.de ([213.202.242.162]:55283 "EHLO app1b.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab1FWPh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:37:59 -0400
Message-ID: <4E035DD1.1030603@kpanic.de>
Date: Thu, 23 Jun 2011 17:37:53 +0200
From: Stefan Assmann <sassmann@kpanic.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org>
In-Reply-To: <20110623141222.GA30003@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.06.2011 16:12, Matthew Garrett wrote:
> On Thu, Jun 23, 2011 at 04:08:32PM +0200, Stefan Assmann wrote:
>> On 23.06.2011 15:39, Matthew Garrett wrote:
>>> Would it be more reasonable to do this in the bootloader? You'd ideally 
>>> want this to be done as early as possible in order to avoid awkward 
>>> situations like your ramdisk ending up in the bad RAM area.
>>
>> Not sure what exactly you are suggesting here. The kernel somehow needs
>> to know what memory areas to avoid so we supply this information via
>> kernel command line.
>> What the bootloader could do is to allow the kernel/initrd to be loaded
>> at an alternative address. That's briefly mentioned in the BadRAM
>> Documentation as well. Is that what you mean or am I missing something?
> 
> For EFI booting we just hand an e820 map to the kernel. It ought to be 
> easy enough to add support for that to the 16-bit entry point as well. 
> Then the bootloader just needs to construct an e820 map of its own. I 
> think grub2 actually already has some support for this. The advantage of 
> this approach is that the knowledge of bad memory only has to exist in 
> one place (ie, the bootloader) - the kernel can remain blisfully 
> unaware.
> 

According to Rick's reply in this thread a damaged row in a DIMM can
easily cause a few thousand entries in the e820 table because it doesn't
handle patterns. So the question I'm asking is, is it acceptable to
have an e820 table with thousands maybe ten-thousands of entries?
I really have no idea of the implications, maybe somebody else can
comment on that.

  Stefan
