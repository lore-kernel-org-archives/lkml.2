Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab1IIIsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:48:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36072 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1IIIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110908235903.GA6370@opensource.wolfsonmicro.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
	<CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
	<CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
	<3110288.bQbb0H2ME1@wuerfel>
	<1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
	<20110908223720.GA21469@n2100.arm.linux.org.uk>
	<20110908224731.GB5201@opensource.wolfsonmicro.com>
	<20110908230102.GB21469@n2100.arm.linux.org.uk>
	<20110908235903.GA6370@opensource.wolfsonmicro.com>
Date: Fri, 9 Sep 2011 14:18:07 +0530
Message-ID: <CAJe_Zhd=-vpQ0oZ2fU0=yjO53pcBPw=xCFCtXotb+J4HAF4dpA@mail.gmail.com>
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform drivers
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linaro-dev@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2011 05:29, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Jassi's suggestion was that we should have some magic to
> automatically generate defaults for the relevant device registrations to
> sidestep these issues.
Perhaps there is some misunderstanding.... no witchcraft is involved here.
To be clear, I suggested moving platform_device definition and registration
from 12 board files to some common platform file and use machine_is_xxx()
to assign names of those platform devices. Btw, omap_init_audio() is already
called from an arch_initcall.
Also please note that currently there's no platform_data needed to be passed.
If that requirement arise in future, an optional set_asoc_platdata(void *pdata)
could be defined beside platform_device creation.
While the idea is not absolutely good, imho, it's certainly an improvement
over this patch. Or am I overlooking something ?
