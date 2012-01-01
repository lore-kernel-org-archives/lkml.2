Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2AAV0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 16:26:15 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:36579 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2AAV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 16:26:13 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 22:27:56 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <201201011322.34483.oliver@neukum.org> <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org> <CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com>
In-Reply-To: <CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201012227.56568.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 1. Januar 2012, 21:30:04 schrieb Linus Torvalds:

> Suspend/resume is *special*, and it's special for a very simple
> reason: unlike bootup or attaching a new device, suspend/resume
> happens WHILE THE USER IS ACTIVE.
> 
> Loading firmware at that time is wrong. It's impossible. You have to
> have the firmware available *before* any processes might need it, but
> at the same time actually loading the firmware may need help from user
> space and/or other devices. It's a chicken-and-egg problem.
> 
> So let me repeat one more time: Loading firmware at resume time is a
> device driver bug. Seriously. How many times do I have to say it?

We accept that. And if everything goes well, we keep that rule.
The problem we are seeing here is a problem in USB's error
handling. It happens as we already have decided that we are
unable to properly resume the device.
 
Ideally usbcore would deal with such devices, but at present the USB layer
is unable to cleanly resume devices that change their IDs during
resume.
Solving this would mean putting all firmware loaders into kernel space.
And the mode switching logic as well.

But IMHO resuming a device can always fail, as it involves actual IO,
so we need a functional error handling at that point.

	Regards
		Oliver
