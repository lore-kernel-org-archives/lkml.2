Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207Ab0HFXuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:50:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:44458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0HFXuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:50:10 -0400
Date: Fri, 6 Aug 2010 16:44:10 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>, john stultz <johnstul@us.ibm.com>,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Message-ID: <20100806234410.GB16793@suse.de>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
 <1280937526.28884.21.camel@work-vm>
 <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
 <1281042665.3405.15.camel@localhost.localdomain>
 <20100805213851.GA13868@suse.de>
 <AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com>
 <20100805223854.GA19511@suse.de>
 <20100806072145.GG28519@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100806072145.GG28519@shisha.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 10:21:45AM +0300, Alexander Shishkin wrote:
> On Thu, Aug 05, 2010 at 03:38:54 -0700, Greg KH wrote:
> > On Fri, Aug 06, 2010 at 12:22:27AM +0200, Kay Sievers wrote:
> > > On Thu, Aug 5, 2010 at 23:38, Greg KH <gregkh@suse.de> wrote:
> > > > On Thu, Aug 05, 2010 at 02:11:05PM -0700, john stultz wrote:
> > > >> On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
> > > >> > On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> > > >> > > Is there a actual use case that you need this for?  I don't really have
> > > >> > > an issue with the code I just really want to make sure the feature would
> > > >> > > be useful enough to justify the API and code maintenance going forward.
> > > >> >
> > > >> > Yes. What we have here is an application which takes care of different means
> > > >> > of time synchronization (trusted time servers, different GSM operators, etc)
> > > >> > and also different kinds of time-based events/notifications (like "dentist
> > > >> > appointment next thursday"). When it encounters a time change that is
> > > >> > made by some other application, it basically wants to disable automatic
> > > >> > time adjustment and trigger the events/notifications which are due at this
> > > >> > (new) time.
> > > >>
> > > >> Ok. Something specific is always more helpful then theoretical uses.
> > > >>
> > > >> I think the filtering is still a bit controversial, so you might want to
> > > >> respin it without that. But otherwise I'm ok with it as long as no one
> > > >> else objects to any of the minor details of the interface
> > > >>
> > > >> GregKH: Does /sys/kernel/time_notify seem ok by you?
> > > >
> > > > Um, it depends, what is that file going to do?  I don't see a
> > > > Documentation/ABI/ entry here that describes it fully :)
> > > 
> > > I think that's really awkward interface, to pass file descriptor
> > > numbers around and write them to magic sysfs files.
> > 
> > Ick, really?  That's not ok for sysfs.
> 
> This is how cgroups notifications work [1], for example.

Yes, but that's not the way that sysfs works.  sysfs is
one-value-per-file simple text files.  With a few binary files that are
"pass-through" to the hardware.

It doesn't have these types of "magic" files, please don't try to add
them without a very large discussion, and boatloads of documentation :)

thanks,

greg k-h
