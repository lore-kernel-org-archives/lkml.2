Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2FUI4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:56:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37653 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897Ab2FUI4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMeQTsYX5dfbX055fb8gU7BUxd+Bjuzaa-hzboaJ9=a6VrEE4w@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
 <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
 <CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
 <CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
 <CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
 <20120612132736.642a4a5a@pyramind.ukuu.org.uk> <CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
 <20120612170412.359967ec@pyramind.ukuu.org.uk> <CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
 <20120613113133.38c1ca8a@pyramind.ukuu.org.uk> <CAH9NwWfseFA91jtwuuui463t1MtjdmuPaXrPrz8rOc+HZ9WeXw@mail.gmail.com>
 <CAMeQTsYX5dfbX055fb8gU7BUxd+Bjuzaa-hzboaJ9=a6VrEE4w@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 21 Jun 2012 10:55:44 +0200
Message-ID: <CAH9NwWd3ud=h2O7_cnqxG4bPZYr993TVWyCueAKy+7d-3=8+1Q@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/13 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>:
> On Wed, Jun 13, 2012 at 2:26 PM, Christian Gmeiner
> <christian.gmeiner@gmail.com> wrote:
>> 2012/6/13 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>>> The basic question is:
>>>
>>> Does this device use the Intel BIOS way of reporting mode information,
>>> or the embedded "GCT" style.
>>>
>>
>> As far as I can tell from the logs, it seems to use the Intel BIOS way.
>>
>> [    2.366174] [drm:psb_intel_opregion_setup], Public ACPI methods supported
>> [    2.366183] [drm:psb_intel_opregion_setup], ASLE supported
>> [    2.366200] gma500 0000:00:02.0: Enabling MSI failed!
>> [    2.366287] [drm] internal display is LVDS display
> Do you still force lvds on as with your first modification or are the fuse
> values being read? As Alan said, we might need to add a DMI quirk
> for this particular board in order to pick LVDS instead of MIPI.
>
> What do you get when running:
> dmidecode -t 1
>

I see a lot "Need to filled by OEM" strings - an other thing to fix in the BIOS.
This should be doable also with the congatec utility.


>> [    2.366363] gma500 0000:00:02.0: SKU values is 0x2a00000.
>> [    2.366371] gma500 0000:00:02.0: LNC core clk is 200MHz.
>> [    2.366389] gma500 0000:00:02.0: drm platform config address is 3ddbd010
>> [    2.366403] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
>> [    2.366484] gma500 0000:00:02.0: Unable to read GCT!
>> [    2.366563] gma500 0000:00:02.0: platform_rev_id is 5
>> [    2.368471] gma500 0000:00:02.0: VBT signature missing
>>
>>
>> I will ask my contact at congatec what they are really using. I hope
>> to get some feedback soon.
>
> As you said in your first post, modes are read from an at24 i2c eeprom,
> so we need to add support for that unless you can live with supplying
> your own modes as boot parameter or in your xorg.conf.
>

Thanks... I will try to generate a VBIOS and see what happens.

--
Christian Gmeiner, MSc
