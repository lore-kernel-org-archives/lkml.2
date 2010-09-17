Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0IQM6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:58:30 -0400
Received: from www.tglx.de ([62.245.132.106]:42482 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0IQM6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:58:30 -0400
Date: Fri, 17 Sep 2010 14:57:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shishkin <virtuoso@slind.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv5 0/7] system time changes notification
In-Reply-To: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
Message-ID: <alpine.LFD.2.00.1009171452270.2416@localhost6.localdomain6>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010, Alexander Shishkin wrote:

> Hi,
> 
> This is the fifth version of system time change notification mechanism
> for linux kernel. The need for it comes from applications which would
> like to keep track of time changes without having to wake up every
> $TIMEOUT and calling gettimeofday().
> 
> An excellent description for one of the usecases, written by Kay Sievers
> (http://kerneltrap.org/mailarchive/linux-kernel/2010/8/5/4603531):
> """
> This is the example Lennart and I thought about when we considered
> adding cron-like stuff to systemd's timer configs, but didn't want to
> do silly things like scheduled checks for the actual time, so we
> delayed this feature until such a notification becomes available.
> 
> Consider we want stuff like "wakeup every day at 3pm", the next wakeup
> might be earlier than the timer we calculated last time, on system
> time changes. We need to re-calculate it. This is necessary for all
> repeating events.
> 
> Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
> hours. Now the system time changes to 2pm, and we would expect to
> wakeup in one hour, but we take 25.

And that's why we have posix-timers with the ability to arm absolute
timers. They already deal with the clock being set.

man timer_settime

Thanks,

	tglx
