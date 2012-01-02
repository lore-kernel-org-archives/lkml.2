Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2ABVXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:23:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62327 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2ABVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:23:44 -0500
MIME-Version: 1.0
In-Reply-To: <4F021CF4.9050205@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <4F0219AB.6010505@fastmail.fm> <CA+55aFx=AEG7X2Y-LoHchgPdwNpeSkBG1J7eXprmO=czEJOD2A@mail.gmail.com>
 <4F021CF4.9050205@fastmail.fm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 13:23:21 -0800
X-Google-Sender-Auth: Uu9O9rCbkZ81IECrnx_4DV2ygYY
Message-ID: <CA+55aFx2NMDSY8rmsToU-zxe+bR-gzsxc8HajNWNWfykVJqd9w@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 1:09 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>
> What about USB "class" drivers e.g. usb-storage. They handle any device
> that reports itself as a usb mass storage device. There could be a
> device that needs to be bootstrapped before it becomes a generic usb
> mass storage device. Do we really want to have to write a new driver
> that is almost identical to the generic driver but handles the USB
> firmware correctly.

I'd hope that the generic driver just expose enough interfaces that
you could basically do a "firmware-load" driver that just loads the
firmware and then attaches the device to the generic driver.

So instead of duplicating the driver, or teaching the generic driver
about magic setup stuff, you could do a "specialized" driver for that
particular device (more likely, that manufacturers devices) and then
have some way to hand it over.

Of course, in the end it does matter what the "class" is. For storage
devices, we really do want the kernel to handle things for us
entirely. For other kinds of devices (and the isight camera does come
to mind) I suspect it's entirely fine to just say "whatever, we don't
care enough, just have some udev rules, load things from user space,
and no, you cannot have a videochat active over a suspend/resume
event".

So while I think kernel drivers should generally strive for "you can
suspend/resume without user space even noticing", I do think that it
depends on the particular device just *how* strict you should be about
that rule. Some devices just don't need that kind of attention.

IOW, I think the kernel should *strive* for doing the right thing, and
I think the firmware loader right now makes it unnecessarily hard to
do things right, but at the same time there are no black-and-white
absolute rules. There are always going to be exceptions where somebody
says "this is a crap device, and it's simply not worth worrying
about".

                   Linus
