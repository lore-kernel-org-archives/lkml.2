Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab0HRXKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:10:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55206 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0HRXKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:10:09 -0400
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 16:09:56 -0700
Message-ID: <1282172996.2865.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 16:55 +0300, Alexander Shishkin wrote:
> Changes since v1:
>  - updated against 2.6.36-rc1,
>  - added notification/filtering options,
>  - added Documentation/ABI/sysfs-kernel-time-notify interface description.
> 
> Certain userspace applications (like "clock" desktop applets or cron) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.
> 
> This patch implements a notification interface via eventfd mechanism. Proccess
> wishing to be notified about time changes should create an eventfd and echo
> its file descriptor along with notification options to /sys/kernel/time_notify.
> After that, any calls to settimeofday()/stime()/adjtimex() made by other
> processes will be signalled to this eventfd. Credits for suggesting the eventfd
> mechanism for this purpose go to Kirill Shutemov.

Hey Alexander, 
	Glad to see this work continue! One thing did strike me as odd in
reading over this: Does adjtimex really make sense to trigger a
notification?  Its not actually changing the time, but alters the freq
that time runs. This freq adjustment is transparent to applications or
timers (unlike something like settimeofday).  So I'm not sure I see why
it is included here.

What use case did you have in mind for it?

thanks
-john


