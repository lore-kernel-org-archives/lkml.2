Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1FJRvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:51:37 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:32916 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087Ab1FJRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:51:35 -0400
Message-ID: <4DF25959.9060603@metafoo.de>
Date: Fri, 10 Jun 2011 19:50:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: Blackfin: Add bf5xx-adau1701 machine
 driver
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <1307726331-28618-2-git-send-email-lars@metafoo.de> <20110610173004.GJ26441@sirena.org.uk>
In-Reply-To: <20110610173004.GJ26441@sirena.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 07:30 PM, Mark Brown wrote:
> On Fri, Jun 10, 2011 at 07:18:50PM +0200, Lars-Peter Clausen wrote:
>> Add a machine driver to support the ADAU1701 SigmaDSP processors on
>> Analog Devices BF5XX evaluation boards.
> 
> So, I keep on complaining about the way these drivers are just generic
> to any random Blackfin plus CODEC combination rather than being board
> specific.  It'd be good if we could improve this, even adding something
> into the driver name to make it clear these are for the EVB would help.

I think this is due, that the codecs them-self sit on an add-on board to the
bf5xx eval boards.
So you have two boards, the bf5xx eval board with has the codec eval board
connected to it. That's why it it is kept so generic. You could connect the
codec eval board to any of the bf5xx boards.

> 
> But it's about the same as all the other drivers so...
> 
>> +static struct snd_soc_dai_link bf5xx_adau1701_dai[] = {
>> +	{
>> +		.name = "adau1701",
>> +		.stream_name = "adau1701",
>> +		.cpu_dai_name = "bfin-i2s.0",
>> +		.codec_dai_name = "adau1701",
>> +		.platform_name = "bfin-i2s-pcm-audio",
>> +		.codec_name = "adau1701.0-0034",
>> +		.ops = &bf5xx_adau1701_ops,
>> +	},
>> +	{
>> +		.name = "adau1701",
>> +		.stream_name = "adau1701",
>> +		.cpu_dai_name = "bfin-i2s.1",
>> +		.codec_dai_name = "adau1701",
>> +		.platform_name = "bfin-i2s-pcm-audio",
>> +		.codec_name = "adau1701.0-0034",
>> +		.ops = &bf5xx_adau1701_ops,
>> +	},
> 
> For example this mapping could vary between systems, and I guess there
> may be some possiblity that the CODEC I2C address could change.

The I2C address is specific to the add-on board and since there is only one
adau1701 eval board it should be static.

- Lars

