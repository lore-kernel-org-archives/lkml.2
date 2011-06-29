Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1F2CcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 22:32:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35554 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1F2CcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 22:32:16 -0400
Message-ID: <4E0A8EAD.40800@gmail.com>
Date: Tue, 28 Jun 2011 21:32:13 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        nico@fluxnic.net
Subject: Re: [PATCH 4/4] ARM: convert PCI defines to variables
References: <1309301859-17651-1-git-send-email-robherring2@gmail.com> <1309301859-17651-5-git-send-email-robherring2@gmail.com> <20110628234130.GJ21898@n2100.arm.linux.org.uk>
In-Reply-To: <20110628234130.GJ21898@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 06:41 PM, Russell King - ARM Linux wrote:
> On Tue, Jun 28, 2011 at 05:57:39PM -0500, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Convert PCIBIOS_MIN_IO, PCIBIOS_MIN_MEM, and PCIMEM_BASE to variables to allow
>> multi-platform builds. This also removes the requirement for a platform to
>> have a mach/hardware.h.
> 
> Please don't include PCIMEM_BASE in that - move that into asm/vga.h and
> call it VGA_BASE because that's really what it is.  There's also the
> matter of a definition of a HAS_ symbol...
> 
Okay. I'm still setting vga_base (no point in this case for a define) in
the platforms' pci code as in all cases vga_base is set to PCI memory
space.

I don't follow your comment about HAS_ symbol.

>> diff --git a/arch/arm/include/asm/vga.h b/arch/arm/include/asm/vga.h
>> index 250a4dd..86290df 100644
>> --- a/arch/arm/include/asm/vga.h
>> +++ b/arch/arm/include/asm/vga.h
>> @@ -2,7 +2,7 @@
>>  #define ASMARM_VGA_H
>>  
>>  #include <linux/io.h>
>> -#include <mach/hardware.h>
>> +#include <asm/pci.h>
>>  
>>  #define VGA_MAP_MEM(x,s)	(PCIMEM_BASE + (x))
>>  
> 
> VGA is not dependent on having PCI - there have been ARM platforms which
> have VGA without PCI.
> 
>> diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
>> index b4ea392..de63ca3 100644
>> --- a/arch/arm/mach-pxa/include/mach/hardware.h
>> +++ b/arch/arm/mach-pxa/include/mach/hardware.h
>> @@ -337,8 +337,6 @@ extern unsigned long get_clock_tick_rate(void);
>>  #endif
>>  
>>  #if defined(CONFIG_MACH_ARMCORE) && defined(CONFIG_PCI)
>> -#define PCIBIOS_MIN_IO		0
>> -#define PCIBIOS_MIN_MEM		0
>>  #define ARCH_HAS_DMA_SET_COHERENT_MASK
>>  #endif
>>  
> 
> This definitely breaks because ARCH_HAS_DMA_SET_COHERENT_MASK needs to
> be picked up by linux/dma-mapping.h.  However, this may already be
> broken as there's no clear path where this reliably happens.

Looks like moving it to mach/memory.h would be the right header. This is
also something to make run-time. Hopefully, the dma mapping work will
address that.

Rob

