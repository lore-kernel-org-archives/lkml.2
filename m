Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2LGIYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:24:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33197 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2LGIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <1985305.LiOKDTFPq4@percival>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com>
	<1354779918-4028-2-git-send-email-acourbot@nvidia.com>
	<20121206144259.136693E0950@localhost>
	<1985305.LiOKDTFPq4@percival>
Date: Fri, 7 Dec 2012 09:24:06 +0100
Message-ID: <CACRpkdYvsSqMrwY9UPLkDLat=tCn4+4t0nB37RmsM0-EGW-bJQ@mail.gmail.com>
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 3:06 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> On Thursday 06 December 2012 22:42:59 Grant Likely wrote:
>> how about "gpio_chip_hwnum()" to somewhat match irqdomain convention?
>
> Sure, matching existing interfaces is better. "git grep hwnum" does not seem
> to reveal much related to irqdomain though?

I think Grant is referring to the similarity with hwirq. Check:
include/linux/irqdomain.h

For example GPIO drivers using irqdomain often look up the
trigging local GPIO pin offset from the irqdomain descriptor
passed with the interrupt like this:

static void foo_gpio_irq_unmask(struct irq_data *d)
    int offset = d->hwirq;
    (...)

Maybe "hwgpio" is an even better choice for the name of this.

Yours,
Linus Walleij
