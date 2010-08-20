Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0HTPj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:39:29 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:35914 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0HTPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:39:26 -0400
Date: Fri, 20 Aug 2010 18:38:25 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Greg KH <gregkh@suse.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-ID: <20100820153825.GG3003@shisha.kicks-ass.net>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
 <20100818155702.bc62b2a6.akpm@linux-foundation.org>
 <4C6C7034.4050501@zytor.com>
 <20100818165303.dd52695a.akpm@linux-foundation.org>
 <20100819040937.GA8646@suse.de>
 <20100819083612.GA13293@shutemov.name>
 <20100819153127.GC2985@suse.de>
 <20100820083723.GA18616@shutemov.name>
 <20100820153346.GA10830@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820153346.GA10830@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 08:33:46 -0700, Greg KH wrote:
> On Fri, Aug 20, 2010 at 11:37:23AM +0300, Kirill A. Shutemov wrote:
> > On Thu, Aug 19, 2010 at 08:31:27AM -0700, Greg KH wrote:
> > > On Thu, Aug 19, 2010 at 11:36:12AM +0300, Kirill A. Shutemov wrote:
> > > > On Wed, Aug 18, 2010 at 09:09:37PM -0700, Greg KH wrote:
> > > > > On Wed, Aug 18, 2010 at 04:53:03PM -0700, Andrew Morton wrote:
> > > > > > Is sysfs the right interface for this thing?  Bear in mind that
> > > > > > CONFIG_SYSFS does exist.  
> > > > > > 
> > > > > > > +		     fd = open("/sys/kernel/time_notify", O_WRONLY);
> > > > > > > +		     fdprintf(fd, "%d 1 0 1 1", efd);
> > > > > > 
> > > > > > why not
> > > > > > 
> > > > > > 		sys_time_notify(efd, 1, 0, 1, 1);
> > > > > 
> > > > > Yeah, that would be much better than a sysfs file, this is abusing the
> > > > > sysfs interface quite a lot.
> > > > 
> > > > Do you really think, that increasing number of syscalls is better then
> > > > fs-based interfaces?
> > > 
> > > As you are pretty much creating a new syscall here anyway, there is no
> > > problem with making it a real one, right?
> > 
> > I think Linux has too many syscalls. Significant part these interfaces
> > would be better to map to a filesystem[s].
> 
> What is the difference between a syscall and a filesystem interface?
> They are both things that we can not change in the future and need to be
> preserved and documented.
> 
> Don't be afraid of syscall's, they don't bite :)
> 
> > > That way you can properly
> > > handle the user/kernel documentation and persistance over time (i.e. you
> > > can't change it.)
> > 
> > On the other, hand properly designed fs-based interface requires less
> > modification of userspeace to use it. Acctually, you can use most of
> > fs-based intefaces directly from shell. No need in libc modifications and
> > utilities to use it from shell or other script language.
> > See cgroup, for example.
> > 
> > > So yes, a syscall would be better, especially as this does not exactly
> > > fit into the model of sysfs, right?
> > 
> > Yes, sysfs is not the best place for it, but...
> 
> You just answered your own question.  Please don't make it in sysfs,
> make it a syscall as it does not fit into sysfs.

Hmm, how about a syscallfs? :)

Regards,
--
Alex
