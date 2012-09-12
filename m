Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322Ab2ILQQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:16:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58986 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab2ILQQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <1347465937-7056-1-git-send-email-cyril@ti.com>
References: <1347465937-7056-1-git-send-email-cyril@ti.com>
Date: Wed, 12 Sep 2012 18:16:09 +0200
X-Google-Sender-Auth: wGlSj2Ng-D3KFipHiLmHQ-ErF5w
Message-ID: <CAMuHMdUuQzD0bq8PifBea2-0Pk7RhmPA0-GAFprsk+vMxMGjGw@mail.gmail.com>
Subject: Re: [PATCH] of: specify initrd location using 64-bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux@openrisc.net,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        a-jacquiot@ti.com, arnd@arndb.de, benh@kernel.crashing.org,
        bigeasy@linutronix.de, blogic@openwrt.org, david.daney@cavium.com,
        dhowells@redhat.com, grant.likely@secretlab.ca, hpa@zytor.com,
        jonas@southpole.se, linus.walleij@linaro.org, linux@arm.linux.org.uk,
        m.szyprowski@samsung.com, mahesh@linux.vnet.ibm.com, mingo@redhat.com,
        monstr@monstr.eu, msalter@redhat.com, nico@linaro.org,
        paul.gortmaker@windriver.com, paulus@samba.org, ralf@linux-mips.org,
        rob.herring@calxeda.com, suzuki@in.ibm.com, tglx@linutronix.de,
        tj@kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 6:05 PM, Cyril Chemparathy <cyril@ti.com> wrote:
> On some PAE architectures, the entire range of physical memory could reside
> outside the 32-bit limit.  These systems need the ability to specify the
> initrd location using 64-bit numbers.
>
> This patch globally modifies the early_init_dt_setup_initrd_arch() function to
> use 64-bit numbers instead of the current unsigned long.

> -void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
> +void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)

Why not phys_addr_t?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
