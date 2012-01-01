Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2AAUjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 15:39:23 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41261 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2AAUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 15:39:20 -0500
Date: Sun, 1 Jan 2012 20:39:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
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
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120101203945.0ebc2f55@pyramind.ukuu.org.uk>
In-Reply-To: <201201011732.23069.marek.vasut@gmail.com>
References: <20111230235421.GA6054@redhat.com>
	<201201011054.47233.marek.vasut@gmail.com>
	<201201011328.41311.oliver@neukum.org>
	<201201011732.23069.marek.vasut@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Device IDs can morph due to a power loss. After resumption another driver
> > would bind.
> 
> What do you mean? I don't think I quite follow.

Lots of USB hardware appears as one device id when powered on, then when
the firmware is loaded turns into something else that becomes relevant to
the user.

So on powerup your wireless card goes

	'I've no idea what I am, feed me firmware for this id"

when it gets the firmware it disconnects, reconnects and says

	"I am a USB wireless card with this id"

When you suspend the power gets killed so the device loses its firmware
and goes back to being a firmware requesting thing on resume.

Worse still - you don't easily know if the device is in fact new and was
added while suspended, or was always there.

So for those devices you do need to load the firmware into them
automatically after the resume to work out what they are and get the MAC
to see if its the same wireless card or not.


Alan
