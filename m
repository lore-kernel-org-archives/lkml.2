Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0KPXSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:18:46 -0500
Received: from tango.0pointer.de ([85.214.72.216]:48285 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab0KPXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:18:45 -0500
Date: Wed, 17 Nov 2010 00:18:25 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116231825.GC27594@tango.0pointer.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116230430.6ccbc48c@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 23:04, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> 
> > And as long as we have no problem with letting everybody know who is
> > logged in, and on which tty we shouldn't waste brain cells on discussing
> > whether it is a problem if they also find out whether that login is
> > currently active or not.
> 
> Thge current kernel supports you not knowing who is using which
> console,

How would that work? Not giving a user ownership of the tty device? That
would break like about every second program. It's too late for this.

And anyway unless the kernel is patched you can even see who is running
which process on the system. And now you become all nervous about
telling people which tty is currently in the fg? Seriously?

Security is a fog granade here. It's a non-issue.

Also, afaics the current ioctl() interface you love so much works on any
tty and gives you that information anyway, right? Some tty fd should be
accessible by about every process and VT_GETSTATE on that and you have
the same information -- and no further perm checking is done at all! So
isn't Kay's approach much nicer, where you can actually protect this
oh-so-precious information in a much tighter fashion thatn with normal
ioctls!

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
