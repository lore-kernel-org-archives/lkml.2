Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2ABVw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:52:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47197 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:52:25 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Mon, 2 Jan 2012 22:52:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <CA+55aFx2NMDSY8rmsToU-zxe+bR-gzsxc8HajNWNWfykVJqd9w@mail.gmail.com> <4F022214.8070906@fastmail.fm>
In-Reply-To: <4F022214.8070906@fastmail.fm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201022252.20139.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/01/12 21:23, Linus Torvalds wrote:
> > On Mon, Jan 2, 2012 at 1:09 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> >> What about USB "class" drivers e.g. usb-storage. They handle any device
> >> that reports itself as a usb mass storage device. There could be a
> >> device that needs to be bootstrapped before it becomes a generic usb
> >> mass storage device. Do we really want to have to write a new driver
> >> that is almost identical to the generic driver but handles the USB
> >> firmware correctly.
> > 
> > I'd hope that the generic driver just expose enough interfaces that
> > you could basically do a "firmware-load" driver that just loads the
> > firmware and then attaches the device to the generic driver.
> 
> Sounds workable.
> 
> To make the firmware caching easier I would propose one extra function
> in addition to the aforemensioned get_firmware / put_firmware - a
> find_firmware function to search the cache and return the appropriate
> firmware blob. It should only be called if the caller already has a
> refcount to the firmware, it's only use is to save every driver saving a
> pointer to the firmware.
> 
> If noone beats me to it I will try and put together an RFC for a new
> version.

The problem is on systems with limited resources, most notably RAM. If you plug 
in many devices at once, many firmwares will be cached at one point, efectivelly 
doing DoS attach on the machine?

Also, how will this solve the suspect-resume issue? What if the device suspends 
only occasionally -- like every 24 hours -- then you'd have the FW cached all 
the time too?

M
> 
> Thanks,
> 
> Jack
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
