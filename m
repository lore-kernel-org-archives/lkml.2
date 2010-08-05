Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab0HEKFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:05:39 -0400
Received: from shutemov.name ([188.40.19.243]:36236 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0HEKFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:05:36 -0400
Date: Thu, 5 Aug 2010 13:05:35 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: lkml@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Message-ID: <20100805100535.GA1754@shutemov.name>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
 <20100804153221.GA29109@shutemov.name>
 <20100804154638.GB28519@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804154638.GB28519@shisha.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 06:46:38PM +0300, Alexander Shishkin wrote:
> On Wed, Aug 04, 2010 at 06:32:21 +0300, Kirill A. Shutemov wrote:
> > On Wed, Aug 04, 2010 at 03:48:28PM +0300, Alexander Shishkin wrote:
> > > Certain userspace applications (like "clock" desktop applets or ntpd) might
> > > want to be notified when some other application changes the system time. It
> > > might also be important for an application to be able to distinguish between
> > > its own and somebody else's time changes.
> > > 
> > > This patch implements a notification interface via eventfd mechanism. Proccess
> > > wishing to be notified about time changes should create an eventfd and echo
> > > its file descriptor to /sys/kernel/time_notify. After that, any calls to
> > > settimeofday()/stime()/adjtimex() made by other processes will be signalled
> > > to this eventfd. Credits for suggesting the eventfd mechanism for this
> > > purpose go te Kirill Shutemov.
> > > 
> > > So far, this implementation can only filter out notifications caused by
> > > time change calls made by the process that wrote the eventfd descriptor to
> > > sysfs, but not its children which (might) have inherited the eventfd. It
> > > is so far not clear to me whether this is bad and more confusing than
> > > excluding such children as well.
> > 
> > I think it's a bad idea to filter notifications. Let's leave it for
> 
> Why?

Someone might want to recieve notifications about its own activity.
It's a policy. Kernel should provide mechanism, not policy.

-- 
 Kirill A. Shutemov
