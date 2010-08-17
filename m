Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab0HQHMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:12:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58738 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0HQHMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:12:50 -0400
MIME-Version: 1.0
In-Reply-To: <4C6A28F6.4090701@monstr.eu>
References: <20100817060051.20467.10072.stgit@angua> <4C6A28F6.4090701@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Aug 2010 01:12:28 -0600
X-Google-Sender-Auth: TbmMjSr1F8bIOZLR5b_k9A8F87Q
Message-ID: <AANLkTimTiaTMXL2xd1m-UJd8hR7kntiKE2Z=7o+GMoME@mail.gmail.com>
Subject: Re: [RFC PATCH] of/microblaze: fix includes so that asm/prom.h
 doesn't need linux/of*.h
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 12:15 AM, Michal Simek <monstr@monstr.eu> wrote:
> Grant Likely wrote:
>>
>> asm/prom.h has some nasty include ordering issues because a number of
>> files assume that linux/of_* is included by prom.h.  This patch fixes
>> the Microblaze occurrences.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> Hi Michal,
>>
>> And here is my patch that fixes all the include issues so the remaining
>> lines
>> can be removed from prom.h.  I'll add this one to my test-devicetree
>> branch
>> along with similar patches to fix powerpc and sparc, and probably merge it
>> in 2.6.37.
>
> That's bad because I don't want to keep pci broken till 2.6.37 especially in
> case that I know that is broken.
>
> If this is the right fix for my issue and you want to merge it in 2.6.37
> then I prefer to use my patch which simple add one header to prom.h and then
> this patch fix it in general in 2.6.37.
>
> What do you think?

heh, I think we're talking across purposes.  I sent 2 patches.

The first patch fixes your immediate issue, and I'll ask Linus to
merge it tomorrow.
The second patch (this patch) allows the rest of the linux/of*.h
includes to be removed from prom.h, but I will not merge that one into
2.6.36 because it is riskier and it isn't a regression fix.

g.


>
> Michal
>
>
>
>>
>> Cheers,
>> g.
>>  arch/microblaze/include/asm/prom.h  |    9 ---------
>>  arch/microblaze/kernel/prom.c       |    3 ++-
>>  arch/microblaze/kernel/prom_parse.c |    3 ++-
>>  arch/microblaze/kernel/setup.c      |    3 ++-
>>  arch/microblaze/pci/pci-common.c    |    1 +
>>  drivers/net/xilinx_emaclite.c       |    1 +
>>  drivers/serial/of_serial.c          |    1 +
>>  drivers/serial/uartlite.c           |    1 +
>>  8 files changed, 10 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/microblaze/include/asm/prom.h
>> b/arch/microblaze/include/asm/prom.h
>> index 101fa09..59c7932 100644
>> --- a/arch/microblaze/include/asm/prom.h
>> +++ b/arch/microblaze/include/asm/prom.h
>> @@ -83,13 +83,4 @@ extern int of_irq_map_pci(struct pci_dev *pdev, struct
>> of_irq *out_irq);
>>  #endif /* __ASSEMBLY__ */
>>  #endif /* __KERNEL__ */
>> -
>> -/* These includes are put at the bottom because they may contain things
>> - * that are overridden by this file.  Ideally they shouldn't be included
>> - * by this file, but there are a bunch of .c files that currently depend
>> - * on it.  Eventually they will be cleaned up. */
>> -#include <linux/of_fdt.h>
>> -#include <linux/of_irq.h>
>> -#include <linux/platform_device.h>
>> -
>>  #endif /* _ASM_MICROBLAZE_PROM_H */
>> diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
>> index 427b13b..cca32f3 100644
>> --- a/arch/microblaze/kernel/prom.c
>> +++ b/arch/microblaze/kernel/prom.c
>> @@ -24,6 +24,8 @@
>>  #include <linux/stringify.h>
>>  #include <linux/delay.h>
>>  #include <linux/initrd.h>
>> +#include <linux/of.h>
>> +#include <linux/of_fdt.h>
>>  #include <linux/bitops.h>
>>  #include <linux/module.h>
>>  #include <linux/kexec.h>
>> @@ -31,7 +33,6 @@
>>  #include <linux/irq.h>
>>  #include <linux/memblock.h>
>>  -#include <asm/prom.h>
>>  #include <asm/page.h>
>>  #include <asm/processor.h>
>>  #include <asm/irq.h>
>> diff --git a/arch/microblaze/kernel/prom_parse.c
>> b/arch/microblaze/kernel/prom_parse.c
>> index 99d9b61..004a276 100644
>> --- a/arch/microblaze/kernel/prom_parse.c
>> +++ b/arch/microblaze/kernel/prom_parse.c
>> @@ -6,8 +6,9 @@
>>  #include <linux/module.h>
>>  #include <linux/ioport.h>
>>  #include <linux/etherdevice.h>
>> +#include <linux/of.h>
>>  #include <linux/of_address.h>
>> -#include <asm/prom.h>
>> +#include <linux/of_irq.h>
>>  #include <asm/pci-bridge.h>
>>  #ifdef CONFIG_PCI
>> diff --git a/arch/microblaze/kernel/setup.c
>> b/arch/microblaze/kernel/setup.c
>> index f5f7688..47c8331 100644
>> --- a/arch/microblaze/kernel/setup.c
>> +++ b/arch/microblaze/kernel/setup.c
>> @@ -24,6 +24,8 @@
>>  #include <linux/param.h>
>>  #include <linux/pci.h>
>>  #include <linux/cache.h>
>> +#include <linux/of.h>
>> +#include <linux/of_fdt.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/dma-mapping.h>
>>  #include <asm/cacheflush.h>
>> @@ -31,7 +33,6 @@
>>  #include <asm/cpuinfo.h>
>>  #include <asm/system.h>
>> -#include <asm/prom.h>
>>  #include <asm/pgtable.h>
>>  DEFINE_PER_CPU(unsigned int, KSP);    /* Saved kernel stack pointer */
>> diff --git a/arch/microblaze/pci/pci-common.c
>> b/arch/microblaze/pci/pci-common.c
>> index 55ef532..2e3c60a 100644
>> --- a/arch/microblaze/pci/pci-common.c
>> +++ b/arch/microblaze/pci/pci-common.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>>  #include <asm/processor.h>
>>  #include <asm/io.h>
>> diff --git a/drivers/net/xilinx_emaclite.c b/drivers/net/xilinx_emaclite.c
>> index ecbbb68..68a4498 100644
>> --- a/drivers/net/xilinx_emaclite.c
>> +++ b/drivers/net/xilinx_emaclite.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/of_address.h>
>>  #include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/of_mdio.h>
>>  #include <linux/phy.h>
>> diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
>> index 2af8fd1..387858e 100644
>> --- a/drivers/serial/of_serial.c
>> +++ b/drivers/serial/of_serial.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/serial_core.h>
>>  #include <linux/serial_8250.h>
>>  #include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/nwpserial.h>
>>  diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
>> index 9b03d7b..95e5c27 100644
>> --- a/drivers/serial/uartlite.c
>> +++ b/drivers/serial/uartlite.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>>  #include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>>  #include <linux/of_platform.h>
>>  /* Match table for of_platform binding */
>>
>
>
> --
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
