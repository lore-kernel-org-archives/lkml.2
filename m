Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2LAQZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:25:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33676 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2LAQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <1353683949-9275-1-git-send-email-lee.jones@linaro.org>
References: <1353683949-9275-1-git-send-email-lee.jones@linaro.org>
Date: Sat, 1 Dec 2012 17:25:10 +0100
Message-ID: <CACRpkdbdCsx_SJvD9i+Geniy_McJb1dujzrSLu+o6bvcjUp_cw@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: Provide the STMPE GPIO driver with its own IRQ Domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, viresh.kumar@linaro.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 4:19 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The STMPE GPIO driver can be used as an IRQ controller by some
> related devices. Here we provide it with its very own IRQ Domain
> so that IRQs can be issued dynamically. This will stand the
> driver in good stead when it is enabled for Device Tree, as this
> it a prerequisite.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

The patch looks bogus since there is no code exercising the added
irqdomain code in this patch, it's basically a no-op in the irq
path, which is wrong for an irqdomain.

It is lacking a irq_create_mapping() in stmpe_gpio_to_irq(),
removal of the irq_base member and usage of
irq_find_mapping() in stmpe_gpio_irq().

Only then will the irqdomain actually be used for what it's
intended for.

So I get the impression that this is one of these "let's
just throw a dummy irqdomain in there so we can use
it with devicetree" kind of things...

Yours,
Linus Walleij
