Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1KWUPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:15:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43322 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1KWUO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAHR064h0=PgKs_yNYVBruuWULEda=PPsVoCbgNwtBgJTcDm=mg@mail.gmail.com>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-9-git-send-email-corentincj@iksaif.net>
	<CANq1E4TPKrig6SUT6OWXFoi=K_Q+3KNd6eZD693zfoJSWGNmGg@mail.gmail.com>
	<CAHR064jzbGKyHbBvO7H9tyEbamQT9-E4bpQAhJvfNiHX9JT0zg@mail.gmail.com>
	<CANq1E4T6Ow2fqq_vc=Py-9rCLYnTGQiBWA0xT6R764GxdXDNvA@mail.gmail.com>
	<CAHR064h0=PgKs_yNYVBruuWULEda=PPsVoCbgNwtBgJTcDm=mg@mail.gmail.com>
Date: Wed, 23 Nov 2011 21:14:55 +0100
Message-ID: <CANq1E4T+JeQbB0zTtpAo3Qyz3Yj3H0EwccvM44nJjCQmDkJPOQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] samsung-laptop: add battery life extender support
From: David Herrmann <dh.herrmann@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, Matthew Garrett <mjg@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 7:11 PM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Wed, Nov 23, 2011 at 6:10 PM, David Herrmann
> <dh.herrmann@googlemail.com> wrote:
>> On Wed, Nov 23, 2011 at 5:54 PM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>>>> My BIOS provides this option, too. However, this driver does not
>>>> detect it on my machine. During initialization I get:
>>>> samsung_laptop: SABI command 0x0078 failed with completion flag 0xaa
>>>>
>>>> Maybe you can help debugging this. If there is something I can test
>>>> via debugfs, just tell me.
>>>
>>> Could you try to load the module with debug=1, type these commands
>>>
>>> $ cd /sys/kernel/debug/
>>> $ echo 0x65 > command
>>> $ for i in d0 d1 d2 d3; echo 0 > $i; done
>>> $ echo 0x80 > d0
>>> $ cat call
>>
>> Would be great if you could add a short comment, what it does, next time ;)
>
> Hum sorry, basically it calls the SABI command 0x65 with 0x80 as the
> first argument byte.
>
>> SABI 0x0065 {0x00000080, 0x00000000, 0x0000, 0x00}
>> SABI {0x00000000, 0x00000000, 0x0000, 0x00}
>>
>> dmesg:
>> [ 4988.985360] This computer supports SABI==f518a
>> [ 4988.985374] SABI header:
>> [ 4988.985384]  SMI Port Number = 0x00b2
>> [ 4988.985393]  SMI Interface Function = 0xc0
>> [ 4988.985402]  SMI enable memory buffer = 0xc1
>> [ 4988.985412]  SMI restore memory buffer = 0xc2
>> [ 4988.985421]  SABI data offset = 0x0f00
>> [ 4988.985429]  SABI data segment = 0xdf01
>> [ 4988.985438]  SABI pointer = 0x000dff10
>> [ 4988.985448] samsung_laptop: Backlight controlled by ACPI video driver
>> [ 4988.985478] samsung_laptop: SABI 0x0065 {0x00000080, 0x00000000,
>> 0x0000, 0x00}
>> [ 4988.991847] samsung_laptop: SABI {0x00000000, 0x00000000, 0x0000, 0x00}
>> [ 4988.991886] samsung_laptop: SABI 0x0067 {0x00000080, 0x00000000,
>> 0x0000, 0x00}
>> [ 4988.993298] samsung_laptop: SABI {0x00000000, 0x00000000, 0x0000, 0x00}
>> [ 4988.993332] samsung_laptop: SABI 0x0069
>> [ 4988.994856] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4988.998294] samsung_laptop: SABI 0x0069
>> [ 4988.999780] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4988.999801] samsung_laptop: SABI 0x0069
>> [ 4989.001247] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4989.001269] samsung_laptop: SABI 0x006a {0x00010001, 0x00000000,
>> 0x0001, 0x02}
>> [ 4989.002847] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4989.007453] samsung_laptop: SABI 0x0069
>> [ 4989.008914] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4989.008936] samsung_laptop: SABI 0x0069
>> [ 4989.010409] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4989.010430] samsung_laptop: SABI 0x006a {0x00010001, 0x00000000,
>> 0x0001, 0x02}
>> [ 4989.011998] samsung_laptop: SABI {0x00010201, 0x00000000, 0x0001, 0x02}
>> [ 4989.012589] samsung_laptop: SABI 0x0078 {0x0000aabb, 0x00000000,
>> 0x0000, 0x00}
>> [ 4989.013996] samsung_laptop: SABI command 0x0078 failed with
>> completion flag 0xaa
>
> Something is very strange here, the 0x65 didn't fail so you should
> really have /sys/devices/platform/samsung/battery_life_extender .
> Are you really sure it's not there ?

Argh. I did see the usb_charge but somehow missed the
battery_life_extender. I am sorry. Works both on my machine and sets
the BIOS flags correctly.

Thanks
David
