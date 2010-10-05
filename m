Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0JEUmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:42:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38802 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754104Ab0JEUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:42:38 -0400
Date: Tue, 5 Oct 2010 13:42:41 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101005204241.GB23315@opensource.wolfsonmicro.com>
References: <4C862EB3.4080006@compulab.co.il>
 <20100907125335.GD25830@sirena.org.uk>
 <201009091027.18176.marek.vasut@gmail.com>
 <20100909094120.GB1988@rakim.wolfsonmicro.main>
 <4CAACA63.6090202@compulab.co.il>
 <20101005161608.GD19730@core.coreip.homeip.net>
 <20101005164037.GA20555@opensource.wolfsonmicro.com>
 <20101005180703.GD21399@core.coreip.homeip.net>
 <20101005185942.GA22808@opensource.wolfsonmicro.com>
 <20101005203508.7df590db@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005203508.7df590db@lxorguk.ukuu.org.uk>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 08:35:08PM +0100, Alan Cox wrote:

> > If the board doesn't use regulators you can just disable the regulator
> > API at which point it compiles out into stubs which report success -
> > this has been the case from day one.  There's only an issue if the board
> > has a regulator configuration which is partially visible to software.

> Which is quite likely on anything complex and means that hardcoding
> regulator assumptions is bad.

When I say "partially visible" I mean where we can't say what's there -
we can cope fine with stuff that isn't software controllable.  The issue
is that we can't automatically discover the system configuration.

> I actually see two ways of attacking that, one is that the dummy
> regulator *and* the compiled in regulator system have a standard
> regulator value that can be passed which means "report success, move
> along nothing to see" that could be passed into drivers, the other is to
> not stick the stuff in drivers.

> I suspect the former may be cleaner ?

I'm afraid I'm having a hard time parsing what you're saying here (what
would a "regulator value" be?), but I suspect that you're trying to
suggest something fairly close to what is already implemented.

The model the regulator API has is that neither the driver for the
regulator nor the driver for the consumer should know anything about the
particular board, with the consumers just requesting the supplies the
device has.  A separate piece of board-specific configuration code
provides a table mapping the physical regulators in the system to the
supplies on the individual chips.  There is an option, currently Kconfig
only, which causes the regulator API to provide a do-nothing dummy
regulator if an attempt is made to request a supply that doesn't exist.
I *think* this dummy regulator corresponds to what you're suggesting
above but like I say I'm having a hard time parsing it.

If the regulator API is compiled out then any attempt to get, enable or
disable a regulator just unconditionally reports success.
