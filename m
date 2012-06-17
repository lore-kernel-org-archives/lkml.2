Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2FQLYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 07:24:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41414 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2FQLYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 07:24:00 -0400
Message-ID: <1339932233.20497.14.camel@henna.lan>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?ISO-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>
To: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>
Cc: 677533@bugs.debian.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 17 Jun 2012 14:23:53 +0300
In-Reply-To: <20120616044137.GB4076@burratino>
References: <20120614162609.4613.22122.reportbug@henna.lan>
	 <20120614215359.GF3537@burratino>
	 <CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
	 <20120616044137.GB4076@burratino>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pe, 2012-06-15 kello 23:41 -0500, Jonathan Nieder kirjoitti:
> Martin-Éric Racine wrote:
> > usb 1-7: new high-speed USB device number 3 using ehci_hcd
> [...]
> > usb 1-7: New USB device found, idVendor=0ac8, idProduct=0321
> > usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > usb 1-7: Product: USB2.0 Web Camera
> > usb 1-7: Manufacturer: Vimicro Corp.
> [...]
> > Linux media interface: v0.10
> > Linux video capture interface: v2.00
> > gspca_main: v2.14.0 registered
> > gspca_main: vc032x-2.14.0 probing 0ac8:0321
> > usbcore: registered new interface driver vc032x
> 
> The device of interest is discovered.
> 
> > gspca_main: ISOC data error: [36] len=0, status=-71
> > gspca_main: ISOC data error: [65] len=0, status=-71
> [...]
> > gspca_main: ISOC data error: [48] len=0, status=-71
> > video_source:sr[3246]: segfault at 0 ip   (null) sp ab36de1c error 14 in cheese[8048000+21000]
> > gspca_main: ISOC data error: [17] len=0, status=-71
> 
> (The above data error spew starts around t=121 seconds and continues
> at a rate of about 15 messages per second.  The segfault is around
> t=154.)
 
> The vc032x code hasn't changed since 3.4.1, so please report your
> symptoms to Jean-François Moine <moinejf@free.fr>, cc-ing
> linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, and either
> me or this bug log so we can track it.  Be sure to mention:
> 
>  - steps to reproduce, expected result, actual result, and how the
>    difference indicates a bug (should be simple enough in this case)

1. Ensure that user 'myself' is a member of the 'video' group.
2. Launch the webcam application Cheese from the GNOME desktop.

Expected result: Cheese displays whatever this laptop's camera sees.

Actual result: Cheese crashes while attempting to access the camera.

>  - how reproducible the bug is (100%?)

100%

>  - which kernel versions you have tested and result with each (what is
>    the newest kernel version that worked?)

It probably was 3.1.0 or some earlier 3.2 release (the upcoming Debian
will release with 3.2.x; 3.4 was only used here for testing purposes),
but I wouldn't know for sure since I don't use my webcam too often.

>  - a log from booting and reproducing the bug, or a link to one

See http://bugs.debian.org/677533 

>  - any other weird symptoms or observations

When testing the camera using the closed-source Skype 4.x compiled for
Debian, the video preferences dialog shows that a USB 2.0 camera is
found at /dev/video0. However, no image is shown. This would confirm the
assumption that the issue lies with the kernel video driver, rather than
with the Gstreamer framework that Cheese uses to access the camera.

> Hopefully someone upstream will have ideas for commands to run or
> patches to apply to further track down the cause.

Let's indeed hope so. Thanks for providing these instructions!

Regards,
Martin-Éric

