Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2GHNB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 09:01:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53820 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2GHNB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 09:01:56 -0400
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <1339932233.20497.14.camel@henna.lan>
References: <20120614162609.4613.22122.reportbug@henna.lan>
	<20120614215359.GF3537@burratino>
	<CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
	<20120616044137.GB4076@burratino>
	<1339932233.20497.14.camel@henna.lan>
Date: Sun, 8 Jul 2012 16:01:53 +0300
X-Google-Sender-Auth: iETyehWAh8sqxeQETyk0c-NWbJE
Message-ID: <CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: =?UTF-8?Q?Jean=2DFran=C3=A7ois_Moine?= <moinejf@free.fr>
Cc: 677533@bugs.debian.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/17 Martin-Éric Racine <martin-eric.racine@iki.fi>:
> pe, 2012-06-15 kello 23:41 -0500, Jonathan Nieder kirjoitti:
>> Martin-Ã‰ric Racine wrote:
>> > usb 1-7: new high-speed USB device number 3 using ehci_hcd
>> [...]
>> > usb 1-7: New USB device found, idVendor=0ac8, idProduct=0321
>> > usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> > usb 1-7: Product: USB2.0 Web Camera
>> > usb 1-7: Manufacturer: Vimicro Corp.
>> [...]
>> > Linux media interface: v0.10
>> > Linux video capture interface: v2.00
>> > gspca_main: v2.14.0 registered
>> > gspca_main: vc032x-2.14.0 probing 0ac8:0321
>> > usbcore: registered new interface driver vc032x
>>
>> The device of interest is discovered.
>>
>> > gspca_main: ISOC data error: [36] len=0, status=-71
>> > gspca_main: ISOC data error: [65] len=0, status=-71
>> [...]
>> > gspca_main: ISOC data error: [48] len=0, status=-71
>> > video_source:sr[3246]: segfault at 0 ip   (null) sp ab36de1c error 14 in cheese[8048000+21000]
>> > gspca_main: ISOC data error: [17] len=0, status=-71
>>
>> (The above data error spew starts around t=121 seconds and continues
>> at a rate of about 15 messages per second.  The segfault is around
>> t=154.)
>
>> The vc032x code hasn't changed since 3.4.1, so please report your
>> symptoms to Jean-FranÃ§ois Moine <moinejf@free.fr>, cc-ing
>> linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, and either
>> me or this bug log so we can track it.  Be sure to mention:
>>
>>  - steps to reproduce, expected result, actual result, and how the
>>    difference indicates a bug (should be simple enough in this case)
>
> 1. Ensure that user 'myself' is a member of the 'video' group.
> 2. Launch the webcam application Cheese from the GNOME desktop.
>
> Expected result: Cheese displays whatever this laptop's camera sees.
>
> Actual result: Cheese crashes while attempting to access the camera.
>
>>  - how reproducible the bug is (100%?)
>
> 100%
>
>>  - which kernel versions you have tested and result with each (what is
>>    the newest kernel version that worked?)
>
> It probably was 3.1.0 or some earlier 3.2 release (the upcoming Debian
> will release with 3.2.x; 3.4 was only used here for testing purposes),
> but I wouldn't know for sure since I don't use my webcam too often.

I finally found time to perform further testing, using kernel packages
from snapshots.debian.org, and the last one that positively worked (at
least using GNOME's webcam application Cheese) was:

linux-image-3.1.0-1-686-pae          3.1.8-2
 Linux 3.1 for modern PCs

This loaded the following video modules:

gspca_vc032x
gspca_main
videodev
media

Tests using 3.2.1-1 or more recent crashed as described before. This
at least gives us a time frame for when the regression started.

Martin-Éric
