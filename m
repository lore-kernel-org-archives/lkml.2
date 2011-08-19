Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1HSL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:59:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39923 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1HSL7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:59:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110709102337.GD9247@sirena.org.uk>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTi=r=N5OwfsVLRuBsNRSpv91pTgeKA@mail.gmail.com>
	<20110709102337.GD9247@sirena.org.uk>
Date: Fri, 19 Aug 2011 13:59:00 +0200
Message-ID: <CACRpkdaqHcY_phZouGn5dJWzF3FKXuP_4Fn-EJZFivrnQRrnKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 9, 2011 at 12:23 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jun 13, 2011 at 01:57:36PM -0600, Grant Likely wrote:
>> On Mon, Jun 13, 2011 at 10:58 AM, Linus Walleij
>>
>> I would *strongly* recommend against individual device drivers
>> accessing the pinmux api.  This is system level configuration code,
>> and should be handled at the system level.
>
> There can also be advantages to putting the pin into the designed mode
> without the driver being loaded from the electrical point of view.  For
> example, selecting appropriate pull values for pads can cut down on
> power consumption.

Since the pin control subsystem is reference counting wrt
mux settings, one does not exclude the other. So for
example a driver may or may not grab a certain set-up of pins
and the core platform may do the same, but when they start to
request different conflicting things the subsystem will complain,
as is apropriate.

So this is a very pure driver framework, without policy, it just
does what it's told, and will prevent undefined and impossible
settings. Atleast that's the idea.

Thanks,
Linus Walleij
