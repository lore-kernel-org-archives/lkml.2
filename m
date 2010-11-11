Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0KKXpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:45:51 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39559 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0KKXpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:45:50 -0500
Subject: Re: [PATCHv6 0/7] system time changes notification
From: john stultz <johnstul@us.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <AANLkTimMWcYc2OF1uS0zwRjMyjSGyysMVAsAFMtyOQ-D@mail.gmail.com>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
	 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net>
	 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
	 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
	 <1289514994.2742.81.camel@work-vm>
	 <AANLkTimMWcYc2OF1uS0zwRjMyjSGyysMVAsAFMtyOQ-D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 15:45:42 -0800
Message-ID: <1289519142.2742.148.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 18:19 -0500, Kyle Moffett wrote:
> Then consider the possibility of creating "virtual clocksources" which
> are measured against an existing clocksource.  They could be
> independently slewed and adjusted relative to the parent clocksource.
> Then the "UTS namespace" feature could also affect the current
> clocksource used for CLOCK_MONOTONIC, etc.
> 
> You could perform various forms of time-sensitive software testing
> without causing problems for a "make" process running elsewhere on the
> system.  You could test the operation of various kinds of software
> across large jumps or long periods of time (at a highly accelerated
> rate) without impacting your development environment.

Oh, and I forgot, if you want to actually do something like this, the
best way is to create a LD_PRELOAD library that intercepts gettimeofday,
clock_gettime, and all the other syscalls that utilize time values and
adjust them as desired.

This way you only affect the specific application and not the rest of
the system, and avoid all the nasty hardware time domain assumptions
that the kernel makes when working with hardware.

thanks
-john


