Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1IHXHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:07:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49797 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753190Ab1IHXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:07:09 -0400
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
 drivers
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-dev@lists.linaro.org, Mans Rullgard <mans.rullgard@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>, alsa-devel@alsa-project.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Date: Thu, 08 Sep 2011 15:29:11 -0700
In-Reply-To: <3110288.bQbb0H2ME1@wuerfel>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
	 <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
	 <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
	 <3110288.bQbb0H2ME1@wuerfel>
Organization: Wolfson Microelectronics
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 22:28 +0200, Arnd Bergmann wrote:
> On Thursday 08 September 2011 20:05:48 Mans Rullgard wrote:

> > I had the same thought, but I couldn't find a suitable string anywhere.
> > Are you suggesting an if(machine_is_foo()) cascade in omap_init_audio()?

> > I'll be the first to agree this patch is not particularly pretty.

> My general feeling is that practically every time someone writes
> machine_is_*(), they are doing it wrong. There are of course exceptions,
> but I would strongly recommend to have the initialization calling up
> from the board file into more general functions instead of having all
> boards calling the same function which then goes to board specific
> code again.

I have to agree, that seems tasteless. I'd expect something like
triggering registration of devices based off walking down a table of
machine IDs or something. One other issue to consider here is that we
don't want to discourage people from sharing machine drivers while we
can so it can't be completely automatic, it 

Perhaps some sort of generic machine type based mechanism for
instantiating drivers a bit like what's done with DMI might be useful,
video will have a similar issue I guess.

