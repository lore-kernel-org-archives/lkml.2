Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0KLChi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:37:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59091 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0KLChh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:37:37 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 11 Nov 2010 18:35:51 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Thomas Gleixner <tglx@linutronix.de>
cc: Kyle Moffett <kyle@moffetthome.net>,
        Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 0/7] system time changes notification
In-Reply-To: <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1011111813070.32375@davide-lnx1>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org> <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net> <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6> <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
 <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Thomas Gleixner wrote:

> > [...]
> > 
> > This would also enable the folks who want to support things like PHY
> > hardware clocks (for very-low-latency ethernet timestamping).  It
> > would resolve the enumeration problem; instead of 0, 1, 2, ... as
> > constants, they would show up in sysfs and be open()able.  Ideally you
> > would be able to set up ntpd to slew the "realtime" clock by following
> > a particular hardware clock, or vice versa.
> 
> There are other plans for the various interesting clocks floating
> around which look pretty good.
> 
> But what you folks really want for this stuff is an extension to
> timerfd as you want to be able to poll, right?
> 
> So what about the following:
> 
> Add a new flag TDF_NOTIFY_CLOCK_WAS_SET to the timerfd flags. Now this
> flag adds the timer to a separate list, which gets woken up when the
> clock is set.

What chu talkin bout Willis? :)
This borders the interface multiplexing, if I got your idea correctly.
Timerfd is about expiring private timers, not about getting out 
notifications about system-wide time changes.
I understand your concerns about that code, but please do not use timerfd 
as a sacrificial mule to fit something which IMO does not belong there.



- Davide


