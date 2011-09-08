Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1IHW5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 18:57:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53566 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752455Ab1IHW5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 18:57:10 -0400
Date: Thu, 8 Sep 2011 15:47:31 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110908224731.GB5201@opensource.wolfsonmicro.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
 <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
 <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
 <3110288.bQbb0H2ME1@wuerfel>
 <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
 <20110908223720.GA21469@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908223720.GA21469@n2100.arm.linux.org.uk>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 11:37:20PM +0100, Russell King - ARM Linux wrote:

> With DT of course, all devices get instantiated from the device tree,
> so there should not be any more platform specific chunks of code in
> these locations (ha, it couldn't be solved with platform data so I
> suspect it will continue to persist, forever unsolved.)

That's not the case at all for audio, the PCB schematic for the audio
subsystem on a device like a smartphone is a sufficiently interesting
piece of hardware to be a device with a driver in its own right.  The
ASoC machine drivers aren't about instantiating devices, they are about
controlling the interrelationships between the various devices in the
audio subsystem.

What will happen for device tree is that there will be a device in the
device tree for the ASoC board.
