Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3AGKVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:21:09 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35410 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3AGKVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:21:07 -0500
MIME-Version: 1.0
In-Reply-To: <1357545943.28451.9.camel@bichao>
References: <1355818296.11831.287.camel@bichao>
	<20121219095616.GV2261@intel.com>
	<CACRpkdaw7Yc0OetPWK7Cv=JsVPOs6b1Tr-=4jE5Vz4oTD6f07Q@mail.gmail.com>
	<1357545943.28451.9.camel@bichao>
Date: Mon, 7 Jan 2013 11:21:04 +0100
Message-ID: <CACRpkdZ9FctBE2zYA8xX3wgf1WOOvb-SMrXDTYDuguiLiUEwbw@mail.gmail.com>
Subject: Re: [PATCH] SPI: SSP SPI Controller driver v3
From: Linus Walleij <linus.walleij@linaro.org>
To: channing <chao.bi@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        sylvain.centelles@intel.com, ken.k.mills@intel.com,
        jun.d.chen@intel.com, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 9:05 AM, channing <chao.bi@intel.com> wrote:

> Frankly I'm currently not sure whether they share same IP.. per your reminds, I tried to find but get
> limited info about PXA SSP's IP, from the code, looks like they have part of registers the same.
>
> As far as I know, spi-pxa2xx.c is specific for SSP controller of PXA2XX/PXA3XX core, right?

As pointed out by Mika it may very well be the same IP anyway. People copy/paste
share and fork VHDL/Verilog/SystemC code just as much as they do with
kernel code.

> While Medfield
> platform is embedded with ATOM core, the SSP driver we upload is validated on SSP controller of ATOM. In my
> view, they're specific for different AP & Platforms, if compare the 2 files, there are still many difference
> in how they works, if to choose a driver for Intel Medfild/Moorestown platform, I believe spi-intel-mid-ssp.c
> driver could be a more mature solution.

>From the kernel community point of view the driver that is being
maintained in-tree
is the more mature solution.

For your productization maybe the other driver is more mature.

These are two different definitions of maturity.

In the kernel we worry that we do not needlessly need to fix bugs in two places
or leave a bug in one place while fixing it in another place, which is
potentially the
problem we run into here.

There may be an initial time/testing cost for you to adopt to the PXA driver,
but on the other hand the PXA developers will review your code and fix
bugs for you also, so it's what we call a win-win situation if you can share
the driver.

Yours,
Linus Walleij
