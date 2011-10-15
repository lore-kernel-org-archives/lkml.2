Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1JOSSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:18:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34911 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1JOSSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:18:21 -0400
Date: Sat, 15 Oct 2011 21:18:08 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
Message-ID: <20111015181808.GA3128@mwesterb-mobl.ger.corp.intel.com>
References: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:42:12AM +0200, Linus Walleij wrote:
>  arch/arm/mach-ep93xx/core.c                     |    1 +
>  arch/arm/mach-ep93xx/edb93xx.c                  |    1 +
>  arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h |  100 +++++++++++++++++++++
>  arch/arm/mach-ep93xx/include/mach/gpio.h        |  105 -----------------------

I just tried to compile latest linux-next and due to missing <mach/gpio.h> I
get:

In file included from include/linux/gpio.h:18:0,
                 from drivers/gpio/gpiolib.c:10:
/home/westeri/devel/kernel/linux/arch/arm/include/asm/gpio.h:5:23: fatal error: mach/gpio.h: No such file or directory
compilation terminated.
make[2]: *** [drivers/gpio/gpiolib.o] Error 1

It looks like arch/arm/include/asm/gpio.h wants to have <mach/gpio.h>. Any idea
how to fix this?
