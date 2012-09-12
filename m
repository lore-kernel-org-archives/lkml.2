Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2ILWIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:08:36 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42142 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2ILWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:08:34 -0400
Message-ID: <505107DF.5020105@gmail.com>
Date: Wed, 12 Sep 2012 17:08:31 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Cyril Chemparathy <cyril@ti.com>, linux-mips@linux-mips.org,
        x86@kernel.org, a-jacquiot@ti.com, mahesh@linux.vnet.ibm.com,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        paul.gortmaker@windriver.com, paulus@samba.org, hpa@zytor.com,
        m.szyprowski@samsung.com, jonas@southpole.se, linux@arm.linux.org.uk,
        linux-c6x-dev@linux-c6x.org, nico@linaro.org, david.daney@cavium.com,
        mingo@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        benh@kernel.crashing.org, suzuki@in.ibm.com, linux@openrisc.net,
        arnd@arndb.de, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, msalter@redhat.com,
        rob.herring@calxeda.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        dhowells@redhat.com, monstr@monstr.eu, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tj@kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] of: specify initrd location using 64-bit
References: <1347465937-7056-1-git-send-email-cyril@ti.com> <CAMuHMdUuQzD0bq8PifBea2-0Pk7RhmPA0-GAFprsk+vMxMGjGw@mail.gmail.com> <5050CE33.9060909@ti.com> <5050E965.5080405@linutronix.de>
In-Reply-To: <5050E965.5080405@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 02:58 PM, Sebastian Andrzej Siewior wrote:
> On 09/12/2012 08:02 PM, Cyril Chemparathy wrote:
>>>> -void __init early_init_dt_setup_initrd_arch(unsigned long start,
>>>> unsigned long end)
>>>> +void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
>>>
>>> Why not phys_addr_t?
>>>
>>
>> The rest of the memory specific bits of the device-tree code use u64 for
>> addresses, and I kept it the same for consistency.
> 
> Geert is right here. If it is a physical address, it should be
> phys_addr_t.

While generally true, for the DT specific code I think it should be a
fixed u64. The size of the address is defined by the FDT, not the
kernel. It is very likely we could have a FDT that specifies addresses
in 64-bit values, but then we boot a kernel is compiled for !LPAE.
phys_addr_t is currently sized based on LPAE setting.

Also, this is how the memory and reserved nodes are handled currently,
so we should be consistent.

Rob

