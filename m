Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KGV2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 16:28:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52254 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KGV2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 16:28:03 -0500
MIME-Version: 1.0
In-Reply-To: <5097F8CF.5090100@wwwdotorg.org>
References: <38620644.IyR5R8rjKP@percival>
	<CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com>
	<5097F8CF.5090100@wwwdotorg.org>
Date: Wed, 7 Nov 2012 22:28:01 +0100
Message-ID: <CACRpkdaUJKs7zx=JWRUb+0Qz2dQU=R5KUK+CoM+nLCgHL99AFA@mail.gmail.com>
Subject: Re: How about a gpio_get(device *, char *) function?
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 6:35 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> [Me]
>> gpio_get() should get an abstract handle just like clk_get() or
>> regulator_get(), not a fixed numeral.
>
> I don't really see why the return type of gpio_get() influences whether
> it can be implemented or not.

It doesn't influence that, but I want to follow the opaqueness design
pattern from irq descriptors and struct clk.

> With board files, some "gpio map" table would simply contain the same
> int GPIO ID value the table as is used anywhere else already. With DT,
> the same xlate function would translate from DT GPIO-chip-relative
> IDs/specifiers into the global number space in the same way that we do
> today via other APIs.

Yes, this part I buy into, just want to see how we can move forward
from there. The coplete nightmare is to introduce something into DT
that nails down a global GPIO numberspace... but I think that is not
the case atleast.

> If the GPIO subsystem were reworked as you propose, this API could be
> reworked in exactly the same way, or if implemented after the rework, it
> would return whatever handle type was in use at the time.

Yes, I just think we should return an opaque struct from day 1, so
just a little, little bit more to shield us.

Yours,
Linus Walleij
