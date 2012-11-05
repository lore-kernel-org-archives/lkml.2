Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2KEOkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:40:20 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63736 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2KEOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:40:16 -0500
MIME-Version: 1.0
In-Reply-To: <2396674.M1Yl70Z09T@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<4684026.MA6h34pt1X@vostro.rjw.lan>
	<CACRpkdbRWPYHBwLVTm-TDRVyp9Kmoaxw0uZg0schn7i0koDKJw@mail.gmail.com>
	<2396674.M1Yl70Z09T@vostro.rjw.lan>
Date: Mon, 5 Nov 2012 15:40:14 +0100
Message-ID: <CACRpkda6jNsKwowdJZ6d7kua5uBPH2tZT8Ka9vheEiPjvEJuUg@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, November 05, 2012 02:28:45 PM Linus Walleij wrote:
>> But since Grant merged the gpiolib-of.c thing and is still the
>> main maintainer I can atleast chicken out by referring to him
>> this time ... hit me back if he doesn't respond and I will
>> have to refactor the world or something.
>
> No need to be grumpy. :-)

Just a little bit ... sorry.

> I forgot to mention that we want to hook up _existing_ drivers to those things,
> and they already use the global GPIO numbers, don't they?

Yes they do, usually this is either passed from the platform using platform
data or handled by device tree lookups to individual drivers.

So you will have to modify each such existing driver to do ACPI
probe akin to the DT codepath and call acpi_get_gpio() on every pin they
need going forward. But that is the plan I guess.

Yours,
Linus Walleij
