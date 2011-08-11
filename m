Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1HKKNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:13:38 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61645 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab1HKKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:13:37 -0400
Message-ID: <4E43AACF.5060701@metafoo.de>
Date: Thu, 11 Aug 2011 12:11:27 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/4] ASoC: Add ADAU1373 codec support
References: <1312948364-2587-1-git-send-email-lars@metafoo.de> <1312948364-2587-2-git-send-email-lars@metafoo.de> <20110811092702.GA18454@opensource.wolfsonmicro.com>
In-Reply-To: <20110811092702.GA18454@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +	SOC_ENUM("Lineout1 Mono Stereo", adau1373_lineout1_mode_enum),
>> +	SOC_ENUM("Speaker Mono Stereo", adau1373_speaker_mode_enum),
> 
> I'd expect these to be platform data/machine data rather than user
> control?  The speaker wiring isn't going to vary dynamically...
>
You still might want to switch, for whatever particular reason, between mono
and stereo at runtime.

>> +	switch (freq / params_rate(params)) {
>> +	case 1024: /* fs */
>> +		div = 0;
>> +		break;
>> +	case 1536: /* 2/3 fs */
>> +		div = 1;
>> +		break;
> 
> These comments look inaccuate, fs is the sample rate so a divide of 1
> would be fs.

div contains the register value representation of that particular divider.
