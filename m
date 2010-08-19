Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0HSPkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:40:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:46546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0HSPkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:40:06 -0400
Date: Thu, 19 Aug 2010 08:31:27 -0700
From: Greg KH <gregkh@suse.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-ID: <20100819153127.GC2985@suse.de>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org> <20100818155702.bc62b2a6.akpm@linux-foundation.org> <4C6C7034.4050501@zytor.com> <20100818165303.dd52695a.akpm@linux-foundation.org> <20100819040937.GA8646@suse.de> <20100819083612.GA13293@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819083612.GA13293@shutemov.name>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 11:36:12AM +0300, Kirill A. Shutemov wrote:
> On Wed, Aug 18, 2010 at 09:09:37PM -0700, Greg KH wrote:
> > On Wed, Aug 18, 2010 at 04:53:03PM -0700, Andrew Morton wrote:
> > > Is sysfs the right interface for this thing?  Bear in mind that
> > > CONFIG_SYSFS does exist.  
> > > 
> > > > +		     fd = open("/sys/kernel/time_notify", O_WRONLY);
> > > > +		     fdprintf(fd, "%d 1 0 1 1", efd);
> > > 
> > > why not
> > > 
> > > 		sys_time_notify(efd, 1, 0, 1, 1);
> > 
> > Yeah, that would be much better than a sysfs file, this is abusing the
> > sysfs interface quite a lot.
> 
> Do you really think, that increasing number of syscalls is better then
> fs-based interfaces?

As you are pretty much creating a new syscall here anyway, there is no
problem with making it a real one, right?  That way you can properly
handle the user/kernel documentation and persistance over time (i.e. you
can't change it.)

So yes, a syscall would be better, especially as this does not exactly
fit into the model of sysfs, right?

thanks,

greg k-h
