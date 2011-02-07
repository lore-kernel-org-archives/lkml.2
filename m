Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1BGWyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:54:08 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:36503 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193Ab1BGWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:54:05 -0500
Message-ID: <4D50785A.7050801@metafoo.de>
Date: Mon, 07 Feb 2011 23:55:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        "Marcel Holtmann \"" <marcel@holtmann.org>
Subject: Adding bluetooth PCM interface support to ASoC (Was: Re: [PATCH 6/7]
 ASoC: Samsung: neo1973_gta02: Fix bluetooth DAI registration)
References: <1297033463-14577-1-git-send-email-lars@metafoo.de> <1297033463-14577-6-git-send-email-lars@metafoo.de> <20110207115906.GD10564@opensource.wolfsonmicro.com> <4D5023A4.3020209@metafoo.de> <20110207170213.GP10564@opensource.wolfsonmicro.com> <4D502DBF.3050205@metafoo.de> <20110207174950.GQ10564@opensource.wolfsonmicro.com> <4D50355A.60500@metafoo.de> <20110207181702.GR10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207181702.GR10564@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 07:17 PM, Mark Brown wrote:
>>> The bluetooth chip is an actual device which I can point to on the
>>> board and schematic, having a struct device to represent a device that's
>>> actually present doesn't seem like a great leap.
> 
>> Well, there is an actual device representing the bt device, but since
>> this is the standard bt usb device I have no idea how we would get an
>> reference to it from within the sound board driver.
> 
> If you've got a real device and a driver binding to it then you can make
> the driver for that device register the DAI from its probe function, no
> need for the machine driver to get involved.
>

The audio hardware setup of the board looks roughly like this:

  [### SOC ###]
   |         |
   | USB     | I2S
   |         |
 [BT]----[Codec]----[Modem]
     PCM        Analog

So the bluetooth chip is handeld by the standard USB BT HCI driver.

I did some research on the topic and it seems that this is a pretty common
setup in embedded devices.
Audio to the bluetooth chip can either be send over the HCI interface (USB in
this case) from the CPU or over the PCM interface from the codec, so that audio
data from the modem to a bluetooth headset doesn't have to be routed through
the CPU.
The PCM interface seems to be part of the bluetooth standard and there are even
registers (PSKEY_PCM_CONFIG32) to configure the PCM format and bit-rate.

This and that neo1973 devices dont seem the only ones using such a setup, it
would naturally make sense to write an ASoC driver to negotiate the PCM format
between the codec and bluetooth chip and maybe do power management. (And
ofcourse register a dai_device).

But the bluetooth audio support seems to be entirely written in userspace. The
in-kernel bluetooth drivers in general seem only to provide a common interface
to the underlying hardware and all of the higher level functionality seems to
be implemented in userspace.
So right now I have no idea where to start if one wanted to add a ASoC driver
which did the bt-dai configuration.

I've Cced Marcel Holtmann and the bluez mailinglist, maybe someone can give
some input on subject.

- Lars
