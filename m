Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1EaCDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:03:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55268 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1EaCDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:03:10 -0400
Date: Mon, 30 May 2011 22:03:00 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: david@lang.hm, Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"D. Jansen" <d.g.jansen@googlemail.com>, david@lang.hm,
	Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	njs@pobox.com, bart@samwel.tk
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
 <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm>
 <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
 <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm>
 <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
 <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm>
 <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 11:24:03PM +0200, D. Jansen wrote:
> > do you really have so many fsync's going on that the disk spins up so much
> > that you would gain 10-20% battery life?
> 
> Yes. Every autosave in LibreOffice triggers one. And I want autosave,
> but I want them in memory, not on disk.

What on *heck* good does an autosave to memory do?  Are you afraid
your X server is going to go poof, or OpenOffice is going to crash on
you?  I can't remember the last time this has happened to me.  It's
typically a system crash or a power loss that causes me to lose an
OpenOffice session.

> > and what makes you think the extra spin-ups from fsyncs will cause your hard
> > drive to fail significantly earlier? (if you have a hard drive with a
> > limited number of spin-up cycles, you probably don't want to use laptop mode
> > at all)
> 
> Experience, see above. Also, this is well described behavior. All hard
> disks are only designed to last a certain number of head loads and
> unloads. Spinning up and down even less.

Modern laptop drives are designed for 600,000 to a million head loads
and unloads.  Open Office by default autosaves once every 15 minutes.
So if you leave your system running (on battery?!?) 24x7, with open
office open all that time, even with HDD which is only rated for 600k
load cycles, that's 4.5 years.  And of course, normally such a system
is powered all the time, and the hard drive shouldn't be spinning down
if you're on the AC mains.

The real fix is that applications need to be fixed to be less
write-happy.  Firefox example, used to request a transactional update
to a sqllite database on every web click.  Laptop mode isn't the right
place to fix this, since if you try to stop the writes from hitting
the disk, you'll still end up burning memory that can't be released
until the data is written to disk.  My guess is that it's not
OpenOffice which is causing you the problem, unless you've adjusted
the autosave interval, in which case it's your own fault.  It's
probably some application like firefox, or syslog.  (Syslog can be
fixed by prefixing syslog.conf entries with the '-' character so that
the files aren't sync'ed after every log update, for example.  Or not
to log as much in the first place.)

					- Ted


