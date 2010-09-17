Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0IQLIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:08:50 -0400
Received: from www.tglx.de ([62.245.132.106]:34306 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0IQLIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:08:49 -0400
Date: Fri, 17 Sep 2010 13:07:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/7] notify userspace about time changes
In-Reply-To: <20100917113325.147734b6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1009171300520.2416@localhost6.localdomain6>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org> <1284675049-23479-2-git-send-email-virtuoso@slind.org> <20100917113325.147734b6@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010, Alan Cox wrote:

> > Certain userspace applications (like "clock" desktop applets or cron) might
> > want to be notified when some other application changes the system time. It
> > might also be important for an application to be able to distinguish between
> > its own and somebody else's time changes.
> 
> A program that cannot work out if it or someone else changed the time is
> very very broken indeed !
> 
> > This patch implements a notification interface via eventfd mechanism. Proccess
> > wishing to be notified about time changes should create an eventfd and pass it
> > to time_change_notify() syscall along with notification options.
> 
> This seems complete overkill and it doesn't really help applications much
> that I can see because of suspend/resume.
> 
> What are your actual use cases ?
> 
> Clocks apps don't care because they check the actual time so notice it
> shfited. Cron and anacron appear to contain the needed internal handling.
> 
> Anything sleeping until a time occurs maybe ? In which case its a lot
> simpler and cleaner than events to provide a new itimer which wakes the
> process when the wall time hits the time specified in the timer.

We already have that. posix timers provide this.

The only case I can imagine where a notification might be interesting
is when something armed an absolute timer on CLOCK_REALTIME and time
is set backwards.

Thanks,

	tglx
