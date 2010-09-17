Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0IQLPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:15:09 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:45876 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0IQLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:15:08 -0400
Date: Fri, 17 Sep 2010 14:08:03 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH 1/7] notify userspace about time changes
Message-ID: <20100917110803.GC10463@shisha.kicks-ass.net>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
 <1284675049-23479-2-git-send-email-virtuoso@slind.org>
 <20100917113325.147734b6@lxorguk.ukuu.org.uk>
 <AANLkTimGG4ocs5r18Fz8bt0v_V+7+HGdxeoze5PtO6G2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimGG4ocs5r18Fz8bt0v_V+7+HGdxeoze5PtO6G2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 12:22:36 +0200, Kay Sievers wrote:
> On Fri, Sep 17, 2010 at 12:33, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Certain userspace applications (like "clock" desktop applets or cron) might
> >> want to be notified when some other application changes the system time. It
> >> might also be important for an application to be able to distinguish between
> >> its own and somebody else's time changes.
> >
> > A program that cannot work out if it or someone else changed the time is
> > very very broken indeed !
> 
> Yeah, that seems a bit weird to me too.

Ok, I get it. Filtering has to go.

> > Clocks apps don't care because they check the actual time so notice it
> > shfited. Cron and anacron appear to contain the needed internal handling.
> 
> Cron wakes up every minute to check if the time has changed. We don't
> want such silly behavior, but there are no other options at the moment
> for scheduling re-occurring events.
> 
> > Anything sleeping until a time occurs maybe ? In which case its a lot
> > simpler and cleaner than events to provide a new itimer which wakes the
> > process when the wall time hits the time specified in the timer.
> 
> That seems not sufficient. The details should be in the changelog of the patch.

Yes, I did include your description of the problem in the 0/7, but
that doesn't seem sufficient. I really need to compile all the
usecases from previous threads and include them in 1/7 as well.

Regards,
--
Alex
