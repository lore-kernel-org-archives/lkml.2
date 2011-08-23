Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1HWPBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:01:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64716 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1HWPBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <s5h7h64p74g.wl%tiwai@suse.de>
References: <CAK7N6vrj8V+7EYLmd92qd+Mae2KZu8K6BVwnwda=3y2vrcDWRw@mail.gmail.com>
	<CAK7N6vrYRbGD14CJn4iNavc8CL_N8e5zqFbpiZ1yzRi-7kdRqA@mail.gmail.com>
	<s5h7h64p74g.wl%tiwai@suse.de>
Date: Wed, 24 Aug 2011 00:01:49 +0900
Message-ID: <CAK7N6vojossDsVa4YQiXfcMSkF02o3OKP1P0r9v4sVqZTqBe_g@mail.gmail.com>
Subject: Re: Headset driver detection problem during bootup
From: anish singh <anish198519851985@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        alsa-devel@alsa-project.org,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Tim Howe <tim.howe@cirrus.com>, Stephen Warren <swarren@nvidia.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 10:52 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sat, 20 Aug 2011 22:21:10 +0900,
> anish singh wrote:
>>
>> adding more information and experts on alsa.
>>
>> On Fri, Aug 19, 2011 at 9:23 PM, anish singh
>> <anish198519851985@gmail.com> wrote:
>> > I need some suggestions for below situation:
>> >
>> > Headset if it is inserted before the device is powered up is
>> > now detected by forcefully calling the interrupt handler in
>> > the probe function of the headset driver.
>> Headset is detected in our andorid device by using a detect gpio
>>  which is turned on when headset is inserted.If the headset
>>  is inserted right from very beginging i.e. before device is even
>>  turned on then we forcefully call the handler and thereby in
>>  handler we check if gpio is turned on or not and do the rest
>> of things.
>>
>> > Once the handler is called then we find out if the headset
>> > is there or not using gpio and then normal detection happens
>> >
>> > Is it the right way to detect the device during power-up?
>> Does not linux have any other way of doing this which i may
>> be missing? How this is handled in the case of ALSA jack i.e.
>> the jack drivers which is using alsa framework for detection?
>> Android doesn't use ALSA framework for reporting JACK.
>
> Judging from the source code, the likely problem is that the driver
> doesn't initialize the switch-state in input device.  The switch-state
> is updated only when GPIO IRQ comes up.
Absolutely right.During bootup we check the gpio and if we find out
that the headset is inserted then we update the switch.In Android
updating the switch is nothing but updating some sysfs file and
generating uevent AFAIK.
>
>
> Takashi
>
