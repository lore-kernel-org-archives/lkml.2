Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2HNMiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:38:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56865 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2HNMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <201208131436.11122.arnd@arndb.de>
References: <CACRpkdaixT=Zn69x9_b9G2nQFm4cu2S5Uo23ww909MJFH2yWwQ@mail.gmail.com>
	<201208131436.11122.arnd@arndb.de>
Date: Tue, 14 Aug 2012 14:38:19 +0200
Message-ID: <CACRpkdbRKfGSuY5A7BRH3rY0vMPxsKYBuzmqWZJNBawQMsAqog@mail.gmail.com>
Subject: Re: [GIT PULL] gpio fixes for v3.6-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Shawn Guo <shawn.guo@linaro.org>, Daniel Mack <zonque@gmail.com>,
        Axel Lin <axel.lin@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>, Julia Lawall <Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 4:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 10 August 2012, Linus Walleij wrote:
>> Daniel Mack (1):
>>       GPIO: gpio-pxa: fix devicetree functions
>>
>
> Unfortunately, this one caused a build regression, see the fix below.
> I also wonder why pxa_irq_domain_ops isn't static.
>
>         Arnd
>
> 8<----
> GPIO: gpio-pxa: fix building without CONFIG_OF
>
> Patch 7212157267 "GPIO: gpio-pxa: fix devicetree functions" added an
> "xlate" function pointer to the irq_domain_ops, but this function
> is nor declared or defined anywhere when CONFIG_OF is disabled, causing
> the build error:
>
> drivers/gpio/gpio-pxa.c:532:11: error: 'irq_domain_xlate_twocell' undeclared here (not in a function)
>
> Extending the DT-only code section to cover the irq_domain_ops
> and the pxa_gpio_dt_ids solves this problem and makes it clearer
> which code is actually used without DT.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied this to my fixes branch.

Yours,
Linus Walleij
