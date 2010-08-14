Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703Ab0HNKmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 06:42:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753454Ab0HNKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 06:42:04 -0400
Date: Sat, 14 Aug 2010 12:41:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, florian@mickler.org,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100814104130.GA29894@elf.ucw.cz>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
 <20100812125712.48b7fc26@virtuousgeek.org>
 <201008130528.21887.rjw@sisk.pl>
 <AANLkTinMmVdAVaCFXyDZpVRmZ9FCWYhtdeM=o4hdoZnT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinMmVdAVaCFXyDZpVRmZ9FCWYhtdeM=o4hdoZnT@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  Arguably, though, this isn't the only possible way to implement a
> > mechanism allowing the system to be suspended automatically when it appears
> > to be inactive.
> >
> > Namely, one can use a user space power manager for this purpose and actually
> > the OLPC project has been doing that successfully for some time, which clearly
> > demonstrates that the Android approach to this problem is not the only one
> > possible.  Moreover, the kernel's system suspend (or hibernate for that matter)
> > code has not been designed to be started from within the kernel.  It's been
> > designed to allow a privileged user space process to request the kernel to
> > put the system into a sleep state at any given time regardless of what the
> > other user space processes are doing.  While it can be started from within the
> > kernel, this isn't particularly nice and, in the Android case, starting it from
> > within the kernel requires permission from multiple user space processes
> > (given by not taking suspend blockers these processes are allowed to use).
> >
> 
> Why is starting suspend from within the kernel not nice? Personally I
> think reentering suspend from within the kernel is nicer than being
> forced to wake up a user space thread for events that are fully
> handled within the kernel (for instance the battery monitor on the
> Nexus One).

For events that are fully handled within the kernel -- like battery
monitor on Zaurus/spitz -- doing wakeup all the way to the userspace
is not neccessary. But that's implementenation detail with no impact
on user/kernel interface, and we are doing that today. (Or were doing
that few releases ago; charging is broken on spitz just now).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
