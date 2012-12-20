Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2LTKFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:05:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50729 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2LTKE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:04:58 -0500
Date: Thu, 20 Dec 2012 10:04:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>, stable@kernel.org
Subject: Re: [PATCH] mfd: db8500-prcmu: fix irqdomain usage
Message-ID: <20121220100452.GG2691@gmail.com>
References: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
 <20121220013218.A55E93E0AD7@localhost>
 <20121220075010.GD2691@gmail.com>
 <CACRpkdZwaTRDD9ZsOcPx+=TfNT0m=5-t6w32195k3Kp=PqvnFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZwaTRDD9ZsOcPx+=TfNT0m=5-t6w32195k3Kp=PqvnFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Linus Walleij wrote:

> On Thu, Dec 20, 2012 at 8:50 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Thu, 20 Dec 2012, Grant Likely wrote:
> >>
> >> This looks wrong. It probably works at the moment, but calling
> >> irq_create_mapping when trying to process an IRQ is backwards. There
> >> certainly shouldn't be any processing of an irq that isn't already
> >> mapped. irq_find_mapping() should be used instead.
> >
> > But irq_create_mapping() calls irq_find_mapping() if the irq is
> > already mapped? Or are you saying that if it isn't already mapped
> > then there is an issue somewhere else earlier in the code?
> 
> I've submitted a v2 patch making the changes I think Grant is
> fishing for..
> 
> Basically irq_create_mapping() should be in slowpath and
> irq_find_mapping() in fastpath with the semantics that
> the former has to be called at least once before the other
> is ever called.

Still seems strange to me. Calling irq_create_mapping() on pre-
mapped IRQs is only a few cycles more and it saves the extra
bumph now inserted into patch v2.

> This is not quite trivial to use ... irqdomain seems like it
> will bite us repeatedly for the next few years.

I agree. Personally I like to call irq_create_mapping(), then
I know that if the IRQ isn't already mapped, it soon will be.
This is almost certainly not the way the Grant intended the
API would be used, but seems simpler and diverts the
complexity you speak of above.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
