Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab2ABD32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 22:29:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34380 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2ABD30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 22:29:26 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Mon, 2 Jan 2012 04:29:23 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <201201011732.23069.marek.vasut@gmail.com> <20120101203945.0ebc2f55@pyramind.ukuu.org.uk>
In-Reply-To: <20120101203945.0ebc2f55@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201020429.23808.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Device IDs can morph due to a power loss. After resumption another
> > > driver would bind.
> > 
> > What do you mean? I don't think I quite follow.
> 
> Lots of USB hardware appears as one device id when powered on, then when
> the firmware is loaded turns into something else that becomes relevant to
> the user.
> 
> So on powerup your wireless card goes
> 
> 	'I've no idea what I am, feed me firmware for this id"
> 
> when it gets the firmware it disconnects, reconnects and says
> 
> 	"I am a USB wireless card with this id"
> 
> When you suspend the power gets killed so the device loses its firmware
> and goes back to being a firmware requesting thing on resume.

Ah, even worse then. I wasn't aware of devices like this at all. Mhmmmm ...

> 
> Worse still - you don't easily know if the device is in fact new and was
> added while suspended, or was always there.

Yea, that's the problem I outlined in the subsequent email.
> 
> So for those devices you do need to load the firmware into them
> automatically after the resume to work out what they are and get the MAC
> to see if its the same wireless card or not.

Sure, but then you'd have to wait for userland to actually be ready to feed 
those. Sometimes, you'd like to avoid that -- for example for devices that are 
always present. But this solution is stupid as it doesn't solve the whole 
problem.

> 
> Alan
