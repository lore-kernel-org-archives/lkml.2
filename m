Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1IEPNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:13:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53462 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754292Ab1IEPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:13:27 -0400
Date: Mon, 5 Sep 2011 08:13:13 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current state of regmap.
Message-ID: <20110905151312.GC3889@opensource.wolfsonmicro.com>
References: <4E64D936.9030904@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E64D936.9030904@cam.ac.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 03:14:14PM +0100, Jonathan Cameron wrote:

> As my previous email said I've been messing around with regmap today.
> I've run into a couple of bugs and was wondering if I'm running
> behind the current version.  I've pulled what is up on kernel.org
> for linux-next at the moment.

That's the current state, I'm running development systems here where all
the I2C and SPI devices on the system go through regmap and anyone
running ASoC will be using it.  Though there's a few patches floating
around now and I'm just testing the module_put() fix so it'll not be the
current state soonish.  kernel.org is closed for updates right now, if I
do much i'll probably show up on opensource.wolfsonmicro.com in the
short term.

> As I'm emailing anyway.  Everywhere other than regmap-debugfs max_register
> is treated as the max valid.  In there we have a loop that is
> for (i = 0; i < map->max_register; i++) so that treats it as one
> larger than the max valid register index.

That's an off by one in the debugfs code, will fix.  You can check this
sort of stuff out by looking at the users.
