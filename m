Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2G3NgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:36:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60910 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456Ab2G3NgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:36:17 -0400
Date: Mon, 30 Jul 2012 14:36:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] GPIO changes for v3.6
Message-ID: <20120730133614.GA4468@opensource.wolfsonmicro.com>
References: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
 <20120730165733.33e3ddfb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730165733.33e3ddfb@notabene.brown>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:57:33PM +1000, NeilBrown wrote:

> it means that if !gpio_is_valid(gpio), the error returned is EPROBE_DEFER 
> which isn't right (an invalid gpio number will never become valid).
> If a driver happened to use gpio_request to check the validity of the gpio
> rather than doing it itself, it would defer the probe, rather than assume
> that the GPIO doesn't exist.

Is anything actually doing this?  For positive numbers that just seems
like it's asking for things to explode, for negative numbers I guess you
can get away with it at the minute though it's obviously not awesome
error handling.

> I would suggest the following.  Reasonable?

TBH I'd actually expect that gpio_is_valid() were checking that there's
a gpio_chip behind the GPIO number, now I look at the implementation
it's very surprising to me that it's just checking the GPIO array bounds
(and also that we remove the need for the fixed size GPIO array which is
just an endless source of annoyance).
