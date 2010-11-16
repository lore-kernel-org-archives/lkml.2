Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0KPXvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:51:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39597 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755793Ab0KPXvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:51:04 -0500
Date: Tue, 16 Nov 2010 23:49:50 +0000
From: Etched Pixels <sales@etchedpixels.co.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116234950.141686c9@etchedpixels.co.uk>
In-Reply-To: <20101116231825.GC27594@tango.0pointer.de>
References: <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<AANLkTinXy3pNhwqo5aqHrH9fN99JhJrBtnbbpnq2h_K-@mail.gmail.com>
	<20101116204906.29d840e9@lxorguk.ukuu.org.uk>
	<20101116214250.GB17824@tango.0pointer.de>
	<20101116225138.4e09f4dc@lxorguk.ukuu.org.uk>
	<20101116225834.GA27594@tango.0pointer.de>
	<20101116230430.6ccbc48c@lxorguk.ukuu.org.uk>
	<20101116231825.GC27594@tango.0pointer.de>
Organization: Etched Pixels: www.etchedpixels.co.uk
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How would that work? Not giving a user ownership of the tty device? That
> would break like about every second program. It's too late for this.

Actually almost nothing in the OS cares about what another user is doing,
and you can have per mount /dev - a  la Plan 9.

> And anyway unless the kernel is patched you can even see who is running
> which process on the system. And now you become all nervous about
> telling people which tty is currently in the fg? Seriously?

procfs, to users.. not in that kind of environment !

> Security is a fog granade here. It's a non-issue.
> 
> Also, afaics the current ioctl() interface you love so much works on any
> tty and gives you that information anyway, right? Some tty fd should be

I'm not particularly attached to the ioctl interface, and I'm not
disagreeing with you that it needs redoing to actually be useful for what
you want and for a lot of other cases. The question is what the resulting
interface should look like so its useful for more than just your specific
current pseudo-secure bits.

> accessible by about every process and VT_GETSTATE on that and you have
> the same information -- and no further perm checking is done at all!

You need to have access to a console fd, which in that case is normally
fine, but it is a weakness and one reason I know about that is because it
has been complained about !

And as you say setting it to 0600 fixes that aspect. I've no problem
with that either as SELinux rules can manage it effectively.

Alan
