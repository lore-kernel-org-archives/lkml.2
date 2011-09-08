Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1IHXiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:38:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65073 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1IHXiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhdGaKFU9kVii83KX+TmN9_edcfCU8TohEzJ4oKaQTEgHw@mail.gmail.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
	<CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
	<CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
	<CAJe_ZhdGaKFU9kVii83KX+TmN9_edcfCU8TohEzJ4oKaQTEgHw@mail.gmail.com>
Date: Thu, 8 Sep 2011 20:26:34 +0100
Message-ID: <CAG5Tg6WjGk71QPOQHoLiMhsUo=49yhyeao_B3aQ+BScJA2xPPw@mail.gmail.com>
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform drivers
From: Mans Rullgard <mans.rullgard@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, alsa-devel@alsa-project.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Jarkko Nikula <jhnikula@gmail.com>,
        linaro-dev@lists.linaro.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 September 2011 20:17, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 9 September 2011 00:35, Mans Rullgard <mans.rullgard@linaro.org> wrote:
>> On 8 September 2011 19:17, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>> On Thu, Sep 8, 2011 at 11:04 PM, Mans Rullgard <mans.rullgard@linaro.org> wrote:
>>>> This converts the per-board modules to platform drivers for a
>>>> device created by in main platform setup.  These drivers call
>>>> snd_soc_register_card() directly instead of going via a "soc-audio"
>>>> device and the corresponding driver in soc-core.
>>>>
>>>> Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
>>>> ---
>>>> Platform device names fixed.
>>>> N8x0 changed to get clocks before registering card.
>>>> ---
>>>>  arch/arm/mach-omap2/board-3430sdp.c          |    6 ++
>>>>  arch/arm/mach-omap2/board-4430sdp.c          |    6 ++
>>>>  arch/arm/mach-omap2/board-am3517evm.c        |    7 +++
>>>>  arch/arm/mach-omap2/board-devkit8000.c       |    6 ++
>>>>  arch/arm/mach-omap2/board-igep0020.c         |    6 ++
>>>>  arch/arm/mach-omap2/board-n8x0.c             |    6 ++
>>>>  arch/arm/mach-omap2/board-omap3beagle.c      |    6 ++
>>>>  arch/arm/mach-omap2/board-omap3evm.c         |    7 +++
>>>>  arch/arm/mach-omap2/board-omap3pandora.c     |    6 ++
>>>>  arch/arm/mach-omap2/board-overo.c            |   17 ++++++
>>>>  arch/arm/mach-omap2/board-rx51.c             |    6 ++
>>>>  arch/arm/mach-omap2/board-zoom-peripherals.c |    6 ++
>>>
>>> Can't we do by having omap_init_audio() in arch/arm/mach-omap2/devices.c
>>> generate a platform device of name depending upon machine_is_* ?
>>
>> I had the same thought, but I couldn't find a suitable string anywhere.
>> Are you suggesting an if(machine_is_foo()) cascade in omap_init_audio()?
> Yes. And you could assign same names as you do now in board init files.

This would still be omap-specific though, but perhaps that can be
acceptable for now.  Longer term, I guess this is a candidate for
device tree.

-- 
Mans Rullgard
Multimedia
mans.rullgard@linaro.org
