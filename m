Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0HRXyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:54:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab0HRXyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:54:35 -0400
Date: Wed, 18 Aug 2010 16:53:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-Id: <20100818165303.dd52695a.akpm@linux-foundation.org>
In-Reply-To: <4C6C7034.4050501@zytor.com>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
	<20100818155702.bc62b2a6.akpm@linux-foundation.org>
	<4C6C7034.4050501@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 16:43:48 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/18/2010 03:57 PM, Andrew Morton wrote:
> > On Wed, 18 Aug 2010 16:55:39 +0300
> > Alexander Shishkin <virtuoso@slind.org> wrote:
> > 
> >> Certain userspace applications (like "clock" desktop applets or cron) might
> >> want to be notified when some other application changes the system time.
> > 
> > The requirements sound a bit fluffy to me.
> > 
> > Any time-displaying application will find out the new time next time
> > it reads the time.  So afaict this is only really useful for clock
> > applets which display once per minute, so they will show the new time
> > promptly after the time was altered, yes?  Is that really worth adding
> > new code for?
> > 
> 
> Actually a much more significant use case was given for the "civil
> periodic" type events: something that wants to happen "every day at
> noon", for example.  The logical thing of sleeping until the next noon
> breaks if the walltime clock is changed.  As such, things like cron have
> to resort to wake up once a minute just to assure themselves that they
> have nothing to do.  This is inefficient, especially for battery-powered
> devices.

OK.

Such applications might be better served via a wake-me-at-this-time
syscall instead of a sleep-me-for-this-long syscall.  Although such a
thing is less general.



Is sysfs the right interface for this thing?  Bear in mind that
CONFIG_SYSFS does exist.  

> +		     fd = open("/sys/kernel/time_notify", O_WRONLY);
> +		     fdprintf(fd, "%d 1 0 1 1", efd);

why not

		sys_time_notify(efd, 1, 0, 1, 1);

?
