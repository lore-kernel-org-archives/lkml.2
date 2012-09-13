Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2IMGsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:48:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:37406 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2IMGsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:48:02 -0400
Message-ID: <5051816A.3050705@linutronix.de>
Date: Thu, 13 Sep 2012 08:47:06 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
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
References: <1347465937-7056-1-git-send-email-cyril@ti.com> <CAMuHMdUuQzD0bq8PifBea2-0Pk7RhmPA0-GAFprsk+vMxMGjGw@mail.gmail.com> <5050CE33.9060909@ti.com> <5050E965.5080405@linutronix.de> <505107DF.5020105@gmail.com>
In-Reply-To: <505107DF.5020105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 12:08 AM, Rob Herring wrote:
>> Geert is right here. If it is a physical address, it should be
>> phys_addr_t.
>
> While generally true, for the DT specific code I think it should be a
> fixed u64. The size of the address is defined by the FDT, not the
> kernel. It is very likely we could have a FDT that specifies addresses
> in 64-bit values, but then we boot a kernel is compiled for !LPAE.
> phys_addr_t is currently sized based on LPAE setting.

If your kernel is 32bit without PAE and your DTB address is >32ibt than
you can't handle it. If you don't notice this in your dt code than you
remap the wrong memory ioremap().

>
> Rob
>

Sebastian
