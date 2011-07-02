Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1GBMk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 08:40:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35939 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1GBMkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 08:40:25 -0400
Message-ID: <4E0F11B3.30803@gmail.com>
Date: Sat, 02 Jul 2011 07:40:19 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 5/6] ARM: convert PCI defines to variables
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <1309366019-24379-6-git-send-email-robherring2@gmail.com> <201107021121.46701.arnd@arndb.de>
In-Reply-To: <201107021121.46701.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 07/02/2011 04:21 AM, Arnd Bergmann wrote:
> Hi Rob,
> 
> On Wednesday 29 June 2011 18:46:58 Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Convert PCIBIOS_MIN_IO and PCIBIOS_MIN_MEM to variables to allow
>> multi-platform builds. This also removes the requirement for a platform to
>> have a mach/hardware.h.
> 
> Good idea.
> 
>> @@ -24,6 +23,12 @@ EXPORT_SYMBOL(ioport_unmap);
>>  #endif
>>  
>>  #ifdef CONFIG_PCI
>> +unsigned long pcibios_min_io;
>> +EXPORT_SYMBOL(pcibios_min_io);
>> +
>> +unsigned long pcibios_min_mem;
>> +EXPORT_SYMBOL(pcibios_min_mem);
>> +
> 
> How about setting these to sensible defaults that will work on
> most platforms, so that the majority won't have to set them at
> all?
> 
> Basically, the defaults should clearly be 
> 
> unsigned long pcibios_min_io  = 0x1000;
> unsigned long pcibios_min_mem = 0x01000000;
> 
> This just gets us out of the ISA bus range, so an ISA card behind
> a bridge can use all cards correctly. Most of the ones that
> currently set both to zero can probably just use those defaults
> as well, but some architectures have multiple buses or don't start
> the memory range at zero, so they might need higher values.

For many platforms, the defaults are 0 for both of these, so I went with
that. Do you think those are just wrong?

Rob

> 
>> --- a/arch/arm/mach-versatile/include/mach/hardware.h
>> +++ b/arch/arm/mach-versatile/include/mach/hardware.h
>> @@ -30,10 +30,6 @@
>>  #define VERSATILE_PCI_VIRT_BASE		(void __iomem *)0xe8000000ul
>>  #define VERSATILE_PCI_CFG_VIRT_BASE	(void __iomem *)0xe9000000ul
>>  
>> -/* CIK guesswork */
>> -#define PCIBIOS_MIN_IO			0x44000000
>> -#define PCIBIOS_MIN_MEM			0x50000000
>> -
>>  /* macro to get at IO space when running virtually */
>>  #define IO_ADDRESS(x)		(((x) & 0x0fffffff) + (((x) >> 4) & 0x0f000000) + 0xf0000000)
>>  
> 
> This PCIBIOS_MIN_IO setting is wrong, and PIO doesn't work on versatile
> because of this. I have an older patch series that I should dig out again
> to fix them and make versatile use the defaults. Don't worry about this
> one.
> 
> 	Arnd

