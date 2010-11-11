Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0KKWL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:11:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43688 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0KKWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:11:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net> <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Thu, 11 Nov 2010 17:11:35 -0500
Message-ID: <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
Subject: Re: [PATCHv6 0/7] system time changes notification
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 16:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> The notification itself is pointless unless your application is
> dealing with timers which need to be adjusted the one way or the
> other.
>
> That said, I'm still not convinced that this usecase justifies a new
> systemcall.
>
> 1) We can make timers wake up when a clock change happens
> 2) Can't we use existing notification stuff like uevents or such ?

What about maybe adding device nodes for various kinds of "clock"
devices?  You could then do:

#define CLOCK_FD 0x80000000
fd = open("/dev/clock/realtime", O_RDWR);
poll(fd);
clock_gettime(CLOCK_FD|fd, &ts);
[...]

This would also enable the folks who want to support things like PHY
hardware clocks (for very-low-latency ethernet timestamping).  It
would resolve the enumeration problem; instead of 0, 1, 2, ... as
constants, they would show up in sysfs and be open()able.  Ideally you
would be able to set up ntpd to slew the "realtime" clock by following
a particular hardware clock, or vice versa.

Cheers,
Kyle Moffett
