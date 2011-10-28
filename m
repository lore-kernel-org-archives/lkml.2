Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab1J1XQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:16:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53221 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1J1XQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <20111028224757.GG23421@pengutronix.de>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
 <1319833618-25190-2-git-send-email-s.hauer@pengutronix.de>
 <20111028215931.GA30366@opensource.wolfsonmicro.com> <20111028224757.GG23421@pengutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 29 Oct 2011 01:16:27 +0200
X-Google-Sender-Auth: b7GAM-U2W_EtMz8N3ZGu5qC--8o
Message-ID: <CAJaTeTr8mtN1VW=Lf4cgpf_xYRYYtmE6kA11kSe2usL=Hw8dTw@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide dummy supply support
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        linux-sh@vger.kernel.org, linux-omap@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 00:47, Sascha Hauer wrote:
> On Fri, Oct 28, 2011 at 11:59:31PM +0200, Mark Brown wrote:
>> On Fri, Oct 28, 2011 at 10:26:58PM +0200, Sascha Hauer wrote:
>>
>> >  drivers/regulator/Makefile        |    2 +-
>> >  drivers/regulator/dummy-supply.c  |   88 +++++++++++++++++++++++++++++++++++++
>>
>> We already have a dummy regulator driver and a fixed voltage regulator
>> driver, we shouldn't be adding a third implementation of the same thing.
>> Just use the fixed voltage regulator for this.
>
> I explained in my mail why I think that the current implementation of
> the dummy regulator is not suitable for things apart from debugging.
>
> My main concern with the fixed regulator is that it needs quite much
> boilerplate code just to say that we have no regulator at all for a
> given device. That could also be handled with a helper function which
> registers a fixed regulator and only takes the regulator_consumer_supply
> as an argument. Would that be ok for you?

i think Mark's point is that we have code in dummy.c already to
provide a dummy regulator.  so your needs sounds like it could be
satisfied with some Kconfig/ifdef massaging and the existing
drivers/regulator/dummy.c rather than introducing a completely
parallel file that is always enabled ?
-mike
