Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1JAWjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:39:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47574 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1JAWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:39:29 -0400
Date: Sat, 1 Oct 2011 23:39:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
Message-ID: <20111001223914.GP11710@n2100.arm.linux.org.uk>
References: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com> <20110920174012.GE7781@ponder.secretlab.ca> <CACRpkdazjpKZRfpoYgZ=kC+auEj9q-KMHa6qsWsD+5Hpji+96w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdazjpKZRfpoYgZ=kC+auEj9q-KMHa6qsWsD+5Hpji+96w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:32:13PM +0200, Linus Walleij wrote:
> On Tue, Sep 20, 2011 at 7:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > Which tree will this go through?  I don't think it should go via the
> > gpio tree since it is mostly within arch/arm.
> 
> It'd dependent on Russells cleanups so it'll go through Russells
> tree and his gpio cleanup branch there.

It's dependent on other stuff elsewhere too:

error: patch failed: drivers/gpio/gpio-ep93xx.c:24
error: drivers/gpio/gpio-ep93xx.c: patch does not apply

According to your patch, line 24 onwards is:

 #include <linux/module.h>
 
 #include <mach/hardware.h>

whereas I have this around line 24:

 #include <linux/basic_mmio_gpio.h>
 
 #include <mach/hardware.h>

So I've applied this with GNU patch instead, accepting the one line of
fuzz:

Hunk #1 succeeded at 23 with fuzz 1 (offset -1 lines).

As a result, I expect sfr will report a trivial merge conflict here.
