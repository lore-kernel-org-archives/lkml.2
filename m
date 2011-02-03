Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1BCMYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:24:04 -0500
Received: from smtp.nokia.com ([147.243.1.48]:63688 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1BCMYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:24:03 -0500
Message-ID: <4D4A9E52.7010000@nokia.com>
Date: Thu, 03 Feb 2011 14:23:46 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110103 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: ext Andres Salomon <dilinger@queued.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
References: <20110202195417.228e2656@queued.net>	<20110202201522.72d37f1e@queued.net>	<20110203060521.GA25739@core.coreip.homeip.net>	<20110202223959.244b4a01@queued.net>	<20110203065339.GA5592@core.coreip.homeip.net> <20110202230326.167fe873@queued.net>
In-Reply-To: <20110202230326.167fe873@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/11 09:03, ext Andres Salomon wrote:
> I believe some drivers are even using the parent device already.  See
> drivers/leds/leds-mc13783.c, for example, whose parent device drvdata
> is used to pass around a struct mc13783 to its children.  Sounds
> like a possibility, will need to look into it further.

I briefly looked at the drivers/leds/leds-mc13783.c, and the related
drivers/mfd/mc13xxx.c drivers.
This also uses the same way to pass the needed platform data to it's
child devices, as the twl4030 (audio/codec/vibra) MFD does.
Also the leds-mc13783.c does not actually uses any config values from
the parent dev. The mc13783_led->master is needed to be locally stored,
since the led driver calls functions from the MFD core, which needs that
as parameter.

I don't really see any need to change the drivers in this regard,
however it would be nicer, if we replace for example the:
	struct twl4030_codec_data *pdata = pdev->dev.platform_data;
with
	struct twl4030_codec_data *pdata = dev_get_platdata(&pdev->dev);

The information passed to the vibra, and ASoC codec driver is for them
only, so there is no need for the vibra driver to know anything about
things, which concerns only the ASoC codec driver.

-- 
Péter
