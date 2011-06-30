Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab1F3Gac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:30:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63101 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1F3Ga0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <1309354437.10872.1.camel@phoenix>
References: <1309354437.10872.1.camel@phoenix>
Date: Thu, 30 Jun 2011 08:30:25 +0200
Message-ID: <BANLkTinkonRXwLC8QanmwYXjmWq=Gtp=hw@mail.gmail.com>
Subject: Re: [PATCH] mach-ux500: fix build error due to unknown 'regulator_en' field
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Axel,

On Wed, Jun 29, 2011 at 3:33 PM, Axel Lin <axel.lin@gmail.com> wrote:

> Fix below build error:
>
>  CC      arch/arm/mach-ux500/board-mop500-u8500uib.o
> arch/arm/mach-ux500/board-mop500-u8500uib.c:35: error: unknown field 'regulator_en' specified in initializer
> arch/arm/mach-ux500/board-mop500-u8500uib.c:35: warning: excess elements in struct initializer
> arch/arm/mach-ux500/board-mop500-u8500uib.c:35: warning: (near initialization for 'rmi4_i2c_dev_platformdata')
> make[1]: *** [arch/arm/mach-ux500/board-mop500-u8500uib.o] Error 1
> make: *** [arch/arm/mach-ux500] Error 2

But uh-oh, that expose our disobedience to the rule that we shall not have
cross-dependencies from stable machines to stuff in staging.

It's tricky this time, since that I2C device is added after first probing
the I2C bus for board type, but I think I have a solution, hold on for
another patch.

Linus Walleij
