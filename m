Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2D1V2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:28:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2D1V16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:27:58 -0400
From: Steffen =?ISO-8859-1?Q?M=FCller?= <steffen.mueller@radio-frei.de>
To: opensuse-factory@opensuse.org
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>, stable@kernel.org,
        Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [opensuse-factory] Re: usb midi keyboard broken [3.3.3 regression] [SOLUTION]
Date: Sat, 28 Apr 2012 23:26:58 +0200
Message-ID: <5861865.YnqskICckP@thinkpadsm.rf-studio>
User-Agent: KMail/4.8.2 (Linux/3.3.3-21-desktop-steffen; KDE/4.8.2; x86_64; ; )
In-Reply-To: <201204281730.04550.oliver@neukum.org>
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org> <14061824.J155VMHgKz@thinkpadsm.rf-studio> <201204281730.04550.oliver@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:Z/HX8+EJsCbZTh8NgoeQ0WVGK610aduwFlVNJAts+qU
 v+RBKh3Tbxgb7kDDFQH8RWanIimPxb6gigNsMbst5Fv1hubmbE
 +ULapv8kVhMj2zZHVyRaKVSqIQRt5n5kihOx0/zXe+gK+3PgKQ
 ncuA7azQlO7zUYTbrxpd5WhUSpsSAdYiiClnTc9TR6EKj9gtlz
 8o/pUVdCCTKSEXDTNN0vRU1wFM+HCjCmC1310DKGxgi3pFk/nS
 pyxDzJmhdCHNbvAJPHmYshvTnHY/XKpC8pZ3UBOhCXUDrVB3l5
 EhpYjPS7i9MAqiH8XIxlY2CTSy5urIeKgqGjFRgoAJf0fkQ8ML
 yNG6Y/DL4AAachHBSzZqNSptYTIa9ngOg68UCvkUolrlzfn+3W
 pgdI5//6J7Rmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. April 2012, 17:30:04 schrieb Oliver Neukum:
> Am Samstag, 28. April 2012, 13:45:56 schrieb Steffen Müller:
> > Oh man! After look and try many usr relevant settings I found the
> > malfactor: tlp usb autosuspend settings.
> > 
> > I use tlp (energy-saving tools for thinkpad laptops) and they autosuspend
> > usb devices by default. Now I have blacklisted my midi keyboard an all is
> > good. I can reproduce the problem this way. Seems so that the midi
> > keyboard doesn't wake up if it once sleeping.
> > 
> > For all with similar problems:
> > edit /etc/default/tlp and set USB_BLACKLIST="<device id from usbls>" or
> > disable usb autosuspend entirely with USB_AUTOSUSPEND=0
> > 
> > thanks and sorry for the bother.
> 
> No problem, but we ought to test whether we can make it work with a kernel
> quirk. Can you please test whether it works with USB_QUIRK_RESET_RESUME
> in drivers/usb/core/quirks.c ?
> 

yes, it works now without blacklisting for autosuspend after build patched 
kernel with this in drivers/usb/core/quirks.c

rf@ThinkpadSM:~/tmp> diff -uNr quirks-org.c quirks.c 
--- quirks-org.c        2012-04-28 23:19:45.440959001 +0200
+++ quirks.c    2012-04-28 20:38:50.000000000 +0200
@@ -123,6 +123,9 @@
        /* Guillemot Webcam Hercules Dualpix Exchange*/
        { USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+       /* Midiman M-Audio Keystation 88es */
+       { USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
+
        /* M-Systems Flash Disk Pioneers */
        { USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
rf@ThinkpadSM:~/tmp> 

regards
steffen
 

> 	Regards
> 		Oliver
