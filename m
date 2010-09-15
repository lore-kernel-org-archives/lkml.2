Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0IOPGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:06:52 -0400
Received: from bosmailout09.eigbox.net ([66.96.188.9]:39288 "EHLO
	bosmailout09.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0IOPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:06:51 -0400
X-Greylist: delayed 2011 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 11:06:51 EDT
X-EN-OrigOutIP: 10.20.18.16
X-EN-IMPSID: 72ZF1f0020LoEWa012ZFc9
Message-ID: <4C90D8AB.9030606@yahoo.es>
Date: Wed, 15 Sep 2010 22:31:07 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Ben Nizette <bn@niasdigital.com>, linux-mmc@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc: Reduce fOD to 200 kHz if possible
References: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>	<9348108E-1108-46FE-8437-6F1271025C61@niasdigital.com> <20100915125138.1f25e4b1@hskinnemoen-d830>
In-Reply-To: <20100915125138.1f25e4b1@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 202.70.59.24
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 15-9-2010 18:51, Haavard Skinnemoen wrote:
> Ben Nizette <bn@niasdigital.com> wrote:
>> On 15/09/2010, at 6:59 PM, Haavard Skinnemoen wrote:
>>
>>> Since the identification frequency was increased to 400 kHz, my
>>> ATSTK1000 board has not been able to initialize any MMC or SD cards.
>>> Reducing the identification mode frequency to 200 kHz fixes the problem.
>>>
>>> This is definitely a board-specific issue, probably due to weak pull-up
>>> resistor values, but this is the simplest fix I could come up with.  
>> I wonder whether there's an Atmel reference schematic around with an
>> incorrect resistor value on it, the only three people I know affected
>> by this are myself, Hein Tibosch and you, all on AVR32.

It was reported by a few more, who wrote me "off-list", but all of them were
using AVR32

> Yes, if you've used the STK1000 schematics as a reference, the resistor
> values are probably a bit on the high side. I can't really suggest any
> better values, as I don't remember what they should be, and the various
> specs are quite inconsistent so it's not straightforward to find the
> best values.
>
> On the other hand, you could argue that the resistor values are fine as
> they are, and that the Linux MMC subsystem is broken because it runs
> the bus faster than what the hardware allows. Replacing the resistors
> with stronger ones might reduce the maximum speed in push-pull mode, so
> I wouldn't necessarily recommend it, especially when it's trivial to fix
> the issue in software.
>

I did find it strange to put the freq at the memory's maximum of 400 Khz

>> We've now submitted one fix each, mine was similar to yours [1] but there's been movement on Hein's more comprehensive patch recently [2].  I don't know who's supposed to be merging MMC patches atm, Chris Ball added on CC on a hunch.
> Thanks for the references. IMO Hein's patch is overkill. There is
> absolutely no reason why 200 kHz should be a problem on any setup, and
> I haven't found any indication in any discussions that it is.
>

I have also seen situations in which the SD will only start up at 180 Khz
or lower.
IMO my patch is indeed a bit of an overkill (the amount of code changed),
I'd rather see a patch like yours or Ben's, but settings fOD at 100 or 50 Khz.

It was Pierre who suggested to try several frequencies[1]: most systems will start
using 400 Khz (so they won't suffer any loss of performance) and in some rare
cases, the SD will only be identified at 100 Khz (which does happen, sometimes)

[1] http://article.gmane.org/gmane.linux.kernel.mmc/994

> The reason why fOD was set to 400 kHz in the first place is that some
> controllers have a very low f_min so running the initialization at that
> frequency causes problems. Which makes sense because the SD standard
> clearly says that the clock can't be slower than 100 kHz.
>
> But I have never seen any reasons why we absolutely _have_ to run the
> clock at the maximum frequency allowed by the spec. In fact, Sascha
> Hauer, who was the one who changed the minimum clock frequency to 400
> kHz, said he would be fine with any frequency between 50 kHz and 400
> kHz

That's right

Hein
