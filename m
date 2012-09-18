Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2IRJ4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:56:49 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:45716 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757836Ab2IRJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:56:47 -0400
Message-ID: <5058458C.5010908@ti.com>
Date: Tue, 18 Sep 2012 12:57:32 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, J Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 13/16] ARM: omap: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-13-git-send-email-arnd@arndb.de> <504F4227.4080206@ti.com> <201209121720.33822.arnd@arndb.de>
In-Reply-To: <201209121720.33822.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 09/12/2012 08:20 PM, Arnd Bergmann wrote:
> On Tuesday 11 September 2012, Peter Ujfalusi wrote:
>> OMAP McBSP has nothing to do with a dsp.
>> A better name would be: ti-mcbsp.h (or leave it as mcbsp.h)
>> McBSP stands for: Multichannel Buffered Serial Port and it is used for audio
>> connection (I2S, TDM, etc).
> 
> changed to asoc-ti-mcbsp.h to, as discussed.
> 
>>>  .../include/plat/dsp.h => include/linux/platform_data/dsp-omap.h   |    0
>>>  .../plat/keypad.h => include/linux/platform_data/keypad-omap.h     |    0
>>>  .../plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h    |    0
>>>  .../plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h    |    0
>>>  .../onenand.h => include/linux/platform_data/mtd-onenand-omap2.h   |    0
>>>  .../remoteproc.h => include/linux/platform_data/remoteproc-omap.h  |    0
>>>  .../voltage.h => include/linux/platform_data/smartreflex-omap.h    |    0
>>>  .../plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h  |    0
>>>  include/linux/power/smartreflex.h                                  |    2 +-
>>
>> Let me see these:
>>
>> This four drivers are going to be removed via sound tree.
>>>  sound/soc/omap/igep0020.c                                          |    2 +-
>>>  sound/soc/omap/omap3beagle.c                                       |    2 +-
>>>  sound/soc/omap/omap3evm.c                                          |    2 +-
>>>  sound/soc/omap/overo.c                                             |    2 +-
>>
>> The new driver which replaces these (omap-twl4030.c) does not include
>> plat/mcbsp.h
> 
> For the sake of bisection, I think we should leave the patch as is.
> When merging the two branches, we will get a small conflict that
> is trivial to resolve.
> 
>> From these ASoC machine drivers you can just remove the <plat/mcbsp.h>
>> include since they should not include them (I have pending patch for this to
>> be sent):
>>>  sound/soc/omap/am3517evm.c                                         |    2 +-
>>>  sound/soc/omap/ams-delta.c                                         |    2 +-
>>>  sound/soc/omap/n810.c                                              |    2 +-
>>>  sound/soc/omap/omap3pandora.c                                      |    2 +-
>>>  sound/soc/omap/osk5912.c                                           |    2 +-
>>>  sound/soc/omap/rx51.c                                              |    2 +-
>>>  sound/soc/omap/sdp3430.c                                           |    2 +-
>>>  sound/soc/omap/zoom2.c                                             |    2 +-
>>
>>>  sound/soc/omap/omap-mcbsp.c                                        |    2 +-
>>>  sound/soc/omap/mcbsp.c                                             |    2 +-
> 
> Can you do that change on top of mine? I would prefer to leave it as is
> because I could create this version with a script.
> 
> The alternative is that I leave the mcbsp.h file alone entirely and you
> submit a patch to fix all instances where it's used, either rename or
> remove them.

I thought I have replied to this...
Whichever way you prefer. I can craft a series to clean up the plat/mcbsp.h
usage and move the mcbsp header via ASoC tree.
I'm also fine if you do the move.
Let me know what you prefer.

Thanks,
Péter
