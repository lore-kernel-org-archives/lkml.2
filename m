Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2GILds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:33:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56374 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2GILdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:33:47 -0400
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <4FF9CA30.9050105@redhat.com>
References: <20120614162609.4613.22122.reportbug@henna.lan>
	<20120614215359.GF3537@burratino>
	<CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
	<20120616044137.GB4076@burratino>
	<1339932233.20497.14.camel@henna.lan>
	<CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com>
	<4FF9CA30.9050105@redhat.com>
Date: Mon, 9 Jul 2012 14:33:46 +0300
X-Google-Sender-Auth: 6ry3i32wgDIX8pqVdo5oiaadwYc
Message-ID: <CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Hans de Goede <hdegoede@redhat.com>
Cc: =?UTF-8?Q?Jean=2DFran=C3=A7ois_Moine?= <moinejf@free.fr>,
        677533@bugs.debian.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/8 Hans de Goede <hdegoede@redhat.com>:
> On 07/08/2012 03:01 PM, Martin-Éric Racine wrote:
>>
>> 2012/6/17 Martin-Éric Racine <martin-eric.racine@iki.fi>:
>>>
>>> pe, 2012-06-15 kello 23:41 -0500, Jonathan Nieder kirjoitti:
>>>>
>>>> Martin-Ã‰ric Racine wrote:
>>>>>
>>>>> usb 1-7: new high-speed USB device number 3 using ehci_hcd
>>>>
>>>> [...]
>>>>>
>>>>> usb 1-7: New USB device found, idVendor=0ac8, idProduct=0321
>>>>> usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>>>> usb 1-7: Product: USB2.0 Web Camera
>>>>> usb 1-7: Manufacturer: Vimicro Corp.
>>>>
>>>> [...]
>>>>>
>>>>> Linux media interface: v0.10
>>>>> Linux video capture interface: v2.00
>>>>> gspca_main: v2.14.0 registered
>>>>> gspca_main: vc032x-2.14.0 probing 0ac8:0321
>>>>> usbcore: registered new interface driver vc032x
>>>>
>>>>
>>>> The device of interest is discovered.
>>>>
>>>>> gspca_main: ISOC data error: [36] len=0, status=-71
>>>>> gspca_main: ISOC data error: [65] len=0, status=-71
>>>>
>>>> [...]
>>>>>
>>>>> gspca_main: ISOC data error: [48] len=0, status=-71
>>>>> video_source:sr[3246]: segfault at 0 ip   (null) sp ab36de1c error 14
>>>>> in cheese[8048000+21000]
>>>>> gspca_main: ISOC data error: [17] len=0, status=-71
>>>>
>>>>
>>>> (The above data error spew starts around t=121 seconds and continues
>>>> at a rate of about 15 messages per second.  The segfault is around
>>>> t=154.)
>>>
>>>
>>>> The vc032x code hasn't changed since 3.4.1, so please report your
>>>> symptoms to Jean-FranÃ§ois Moine <moinejf@free.fr>, cc-ing
>>>> linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, and either
>>>> me or this bug log so we can track it.  Be sure to mention:
>>>>
>>>>   - steps to reproduce, expected result, actual result, and how the
>>>>     difference indicates a bug (should be simple enough in this case)
>>>
>>>
>>> 1. Ensure that user 'myself' is a member of the 'video' group.
>>> 2. Launch the webcam application Cheese from the GNOME desktop.
>>>
>>> Expected result: Cheese displays whatever this laptop's camera sees.
>>>
>>> Actual result: Cheese crashes while attempting to access the camera.
>>>
>>>>   - how reproducible the bug is (100%?)
>>>
>>>
>>> 100%
>>>
>>>>   - which kernel versions you have tested and result with each (what is
>>>>     the newest kernel version that worked?)
>>>
>>>
>>> It probably was 3.1.0 or some earlier 3.2 release (the upcoming Debian
>>> will release with 3.2.x; 3.4 was only used here for testing purposes),
>>> but I wouldn't know for sure since I don't use my webcam too often.
>>
>>
>> I finally found time to perform further testing, using kernel packages
>> from snapshots.debian.org, and the last one that positively worked (at
>> least using GNOME's webcam application Cheese) was:
>>
>> linux-image-3.1.0-1-686-pae          3.1.8-2
>>   Linux 3.1 for modern PCs
>>
>> This loaded the following video modules:
>>
>> gspca_vc032x
>> gspca_main
>> videodev
>> media
>>
>> Tests using 3.2.1-1 or more recent crashed as described before. This
>> at least gives us a time frame for when the regression started.
>
>
> Hmm, this is then likely caused by the new isoc bandwidth negotiation code
> in 3.2, unfortunately the vc032x driver is one of the few gspca drivers
> for which I don't have a cam to test with. Can you try to build your own
> kernel from source?
>
> Boot into your own kernel, and verify the regression is still there,
> then edit drivers/media/video/gspca/gspca.c and go to the which_bandwidth
> function, and at the beginning of this function add the following line:
>
> return 2000 * 2000 * 120;
>
> Then rebuild and re-install the kernel and try again.
>
> If that helps, remove the added
> return 2000 * 2000 * 120;
> line, and also remove the following lines from which_bandwidth:
>
>         /* if the image is compressed, estimate its mean size */
>         if (!gspca_dev->cam.needs_full_bandwidth &&
>             bandwidth < gspca_dev->cam.cam_mode[i].width *
>                                 gspca_dev->cam.cam_mode[i].height)
>                 bandwidth = bandwidth * 3 / 8;  /* 0.375 */
>
> And try again if things still work this way.
>
> Once you've tested this I can try to write a fix for this.

Hans,

Thank you for your reply.

Just to eliminate the possibility of mistakes on my part while trying
to perform the above changes, could you send me a patch against Linux
3.2.21 that I could apply as-is, before building myself a test kernel
package?

Cheers!
Martin-Éric
