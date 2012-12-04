Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LDJOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:14:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59478 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2LDJOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:14:23 -0500
Date: Tue, 4 Dec 2012 09:14:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, viresh.kumar@linaro.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/1] gpio: Provide the STMPE GPIO driver with its own IRQ
 Domain
Message-ID: <20121204091417.GE2718@gmail.com>
References: <1353683949-9275-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdbdCsx_SJvD9i+Geniy_McJb1dujzrSLu+o6bvcjUp_cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbdCsx_SJvD9i+Geniy_McJb1dujzrSLu+o6bvcjUp_cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2012, Linus Walleij wrote:

> On Fri, Nov 23, 2012 at 4:19 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The STMPE GPIO driver can be used as an IRQ controller by some
> > related devices. Here we provide it with its very own IRQ Domain
> > so that IRQs can be issued dynamically. This will stand the
> > driver in good stead when it is enabled for Device Tree, as this
> > it a prerequisite.
> >
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> The patch looks bogus since there is no code exercising the added
> irqdomain code in this patch, it's basically a no-op in the irq
> path, which is wrong for an irqdomain.
> 
> It is lacking a irq_create_mapping() in stmpe_gpio_to_irq(),
> removal of the irq_base member and usage of
> irq_find_mapping() in stmpe_gpio_irq().
> 
> Only then will the irqdomain actually be used for what it's
> intended for.
> 
> So I get the impression that this is one of these "let's
> just throw a dummy irqdomain in there so we can use
> it with devicetree" kind of things...

It's not meant to be bogus, as it will be used.

Albeit, we are not uses of the GPIO functionality AFAICT.

I'll look at your comments in a bit and fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
