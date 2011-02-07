Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1BGRff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:35:35 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:49501 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296Ab1BGRfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:35:34 -0500
Message-ID: <4D502DBF.3050205@metafoo.de>
Date: Mon, 07 Feb 2011 18:37:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ASoC: Samsung: neo1973_gta02: Fix bluetooth DAI registration
References: <1297033463-14577-1-git-send-email-lars@metafoo.de> <1297033463-14577-6-git-send-email-lars@metafoo.de> <20110207115906.GD10564@opensource.wolfsonmicro.com> <4D5023A4.3020209@metafoo.de> <20110207170213.GP10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207170213.GP10564@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 06:02 PM, Mark Brown wrote:
> Please fix your MUA to word wrap at less than 80 columns, I've reflowed
> your text so it's legible.
> 
> On Mon, Feb 07, 2011 at 05:53:56PM +0100, Lars-Peter Clausen wrote:
> 
>>> In any
>>> case, we clearly shouldn't be applying patches which bodge around the
>>> core.
> 
>> Well the alternative would be a patch looking like this:
> 
>> -	.cpu_dai_name = "bluetooth-dai",
>> +	.cpu_dai_name = "soc-core",
> 
>> Which isn't really nice either.
> 
> If you think the core isn't behaving helpfully the core should be
> changed.  This is part of how APIs evolve to be maximally useful.
> 

As I see it the problem is that we have a deviceless dai and there is not really a
way to register a dai without a device. But I have no idea right now how to change
the core to make it "behave helpfully".

And in a sense snd_soc_register_dais seems to be the right thing to use for now,
because the sound card as a whole has multiple dais they just not all registered at
the same time.

> To be honest it's not massively obvious that we shouldn't just be taking
> the name of the device here, either using a device to represent the
> modem

Seriously? I don't see how adding a dummy device wouldn't be "bodging around the
core". Especially if using snd_soc_register_dais is.

> or registering the card using snd_soc_register_machine() and using
> a more meaningful name for the card seems like a sensible approach here.

Well, if were using snd_soc_register_machine to give the card a different name the
bluetooth-dai would still be named after the card, wouldn't it? So there is no
improvement here as to giving the dai a meaningful name.

- Lars
