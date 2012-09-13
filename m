Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2IMVC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:02:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58916 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab2IMVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:02:54 -0400
Message-ID: <505249F9.7050201@gmail.com>
Date: Thu, 13 Sep 2012 16:02:49 -0500
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
References: <1347465937-7056-1-git-send-email-cyril@ti.com> <CAMuHMdUuQzD0bq8PifBea2-0Pk7RhmPA0-GAFprsk+vMxMGjGw@mail.gmail.com> <5050CE33.9060909@ti.com> <5050E965.5080405@linutronix.de> <505107DF.5020105@gmail.com> <5051816A.3050705@linutronix.de>
In-Reply-To: <5051816A.3050705@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 01:47 AM, Sebastian Andrzej Siewior wrote:
> On 09/13/2012 12:08 AM, Rob Herring wrote:
>>> Geert is right here. If it is a physical address, it should be
>>> phys_addr_t.
>>
>> While generally true, for the DT specific code I think it should be a
>> fixed u64. The size of the address is defined by the FDT, not the
>> kernel. It is very likely we could have a FDT that specifies addresses
>> in 64-bit values, but then we boot a kernel is compiled for !LPAE.
>> phys_addr_t is currently sized based on LPAE setting.
> 
> If your kernel is 32bit without PAE and your DTB address is >32ibt than
> you can't handle it. If you don't notice this in your dt code than you
> remap the wrong memory ioremap().

The size of the initrd fields are set by #address-cells properties and
determined when you create the dtb. The address to load the initrd is
decided by the bootloader/user and set at that point later in time. The
dtb should not be tied to the kernel you are booting. Obviously, if you
want to boot a non-PAE kernel, everything has to be placed at <4GB.

I can boot i386 and i386-pae kernels on an i386-pae machines. I expect
to generally be able to do that on ARM. Perhaps some SOCs like this one
will not allow that, it is not always true.

Rob

