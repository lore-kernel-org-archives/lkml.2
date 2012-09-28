Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2I1LeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:34:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2I1LeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <50657356.4010801@antcom.de>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
	<CACRpkdZ+1ffsMDRZXYb5RRndoXstj_QHvHOpeikRY0bas72dKQ@mail.gmail.com>
	<50657356.4010801@antcom.de>
Date: Fri, 28 Sep 2012 13:34:18 +0200
Message-ID: <CACRpkdbEgBqSdZmebw+PBMo9G_Y24mgz17=dp11VrbKf5fKyDQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, Bill Gatliff <bgat@billgatliff.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:52 AM, Roland Stigge <stigge@antcom.de> wrote:

> It's hard to do the one-value-per-file right for a several-gpios-at-once
> goal. :-)

That's true. This is one of the reasons I think GPIO chips should
be /dev/gpioN device nodes and this business be handled by
ioctl():s instead, it is harder from an ABI point of view but can
do several things at once.

> I originally had a one-value solution: A bit map, continuously
> hex coded, like in the original kernel API idea (e.g. 0x000F0A0010).
> Wasn't sure because it encodes GPIO numbers in a weird way.

Yeah, well that is not so nice either.

> Strictly formally: Isn't a comma-separated list of a GPIO block (e.g.
> "80,81,85") a singe value in a sense? :-)

I think it's called an array ...

> Or other possibilities? Maybe
> some node in /proc?

Heaven's no.

> Or some kind of new character device node?

Yes, I don't know if we should create /dev/gpioN or /dev/pinctrlN for
this, and add GPIO functions to pinctrl (while wrapping it in the
gpiolib to aid migration) the latter would encourage users of the
new ABI to switch to writing pinctrl drivers.

> Otherwise, I need to think about leaving out the sysfs for this purpose.

Do you really need it?

Yours,
Linus Walleij
