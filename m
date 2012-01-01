Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2AAVjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 16:39:32 -0500
Received: from bues.ch ([80.190.117.144]:38305 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab2AAVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 16:39:31 -0500
Date: Sun, 1 Jan 2012 22:39:13 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120101223913.3ff57d0f@milhouse>
In-Reply-To: <201201012227.56568.oliver@neukum.org>
References: <201201011322.34483.oliver@neukum.org>
	<Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
	<CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com>
	<201201012227.56568.oliver@neukum.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jan 2012 22:27:56 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Ideally usbcore would deal with such devices, but at present the USB layer
> is unable to cleanly resume devices that change their IDs during
> resume.
> Solving this would mean putting all firmware loaders into kernel space.
> And the mode switching logic as well.

I don't get it. Why would a device enter a state after resume, that it was not
in at _any_ time before the machine was suspended?

These change-id-on-bootstrap devices usually work like this,
as far as I know:

probe bootstrap device (switches hw to real device)
probe real device (firmware is loaded)
Suspend machine
Resume machine
usb detects that the device is "gone"
probe/resume bootstrap device (switches hw to real device)
probe/resume real device (No need to fetch fw from userspace. It's already cached)

What did I get wrong?

-- 
Greetings, Michael.
