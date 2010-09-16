Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0IPWaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:30:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53186 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0IPWav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:30:51 -0400
Subject: Re: [PATCH 1/7] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <1284675049-23479-2-git-send-email-virtuoso@slind.org>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
	 <1284675049-23479-2-git-send-email-virtuoso@slind.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 15:30:40 -0700
Message-ID: <1284676240.2669.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 01:10 +0300, Alexander Shishkin wrote:
> Certain userspace applications (like "clock" desktop applets or cron) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.
> 
> This patch implements a notification interface via eventfd mechanism. Proccess
> wishing to be notified about time changes should create an eventfd and pass it
> to time_change_notify() syscall along with notification options.
> After that, any calls to settimeofday()/stime()/adjtimex() made by other
> processes will be signalled to this eventfd. Credits for suggesting the eventfd
> mechanism for this purpose go to Kirill Shutemov.

One thing I have thought of since the last time you posted this, maybe
it would be worth adding a clockid field to the syscall?

Basically, we're looking at extending the posix clocks interfaces to
allow for additional clock hardware to be exposed (See the discussion on
PTP and my CLOCK_RTC patch today for examples and details).

So it seems possible that folks would want a similar interface to catch
updates to non CLOCK_REALTIME clocks.

Does this seem reasonable?

thanks
-john

