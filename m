Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2FMTut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:50:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63330 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2FMTur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9NwWfseFA91jtwuuui463t1MtjdmuPaXrPrz8rOc+HZ9WeXw@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
	<CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
	<CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
	<CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
	<CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
	<20120612132736.642a4a5a@pyramind.ukuu.org.uk>
	<CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
	<20120612170412.359967ec@pyramind.ukuu.org.uk>
	<CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
	<20120613113133.38c1ca8a@pyramind.ukuu.org.uk>
	<CAH9NwWfseFA91jtwuuui463t1MtjdmuPaXrPrz8rOc+HZ9WeXw@mail.gmail.com>
Date: Wed, 13 Jun 2012 21:50:47 +0200
Message-ID: <CAMeQTsYX5dfbX055fb8gU7BUxd+Bjuzaa-hzboaJ9=a6VrEE4w@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 2:26 PM, Christian Gmeiner
<christian.gmeiner@gmail.com> wrote:
> 2012/6/13 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> The basic question is:
>>
>> Does this device use the Intel BIOS way of reporting mode information,
>> or the embedded "GCT" style.
>>
>
> As far as I can tell from the logs, it seems to use the Intel BIOS way.
>
> [    2.366174] [drm:psb_intel_opregion_setup], Public ACPI methods supported
> [    2.366183] [drm:psb_intel_opregion_setup], ASLE supported
> [    2.366200] gma500 0000:00:02.0: Enabling MSI failed!
> [    2.366287] [drm] internal display is LVDS display
Do you still force lvds on as with your first modification or are the fuse
values being read? As Alan said, we might need to add a DMI quirk
for this particular board in order to pick LVDS instead of MIPI.

What do you get when running:
dmidecode -t 1

> [    2.366363] gma500 0000:00:02.0: SKU values is 0x2a00000.
> [    2.366371] gma500 0000:00:02.0: LNC core clk is 200MHz.
> [    2.366389] gma500 0000:00:02.0: drm platform config address is 3ddbd010
> [    2.366403] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
> [    2.366484] gma500 0000:00:02.0: Unable to read GCT!
> [    2.366563] gma500 0000:00:02.0: platform_rev_id is 5
> [    2.368471] gma500 0000:00:02.0: VBT signature missing
>
>
> I will ask my contact at congatec what they are really using. I hope
> to get some feedback soon.

As you said in your first post, modes are read from an at24 i2c eeprom,
so we need to add support for that unless you can live with supplying
your own modes as boot parameter or in your xorg.conf.

-Patrik
