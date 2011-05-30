Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1E3WSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 18:18:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10528 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1E3WSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 18:18:35 -0400
Date: Tue, 31 May 2011 00:10:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
        Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105310001010.8082@swampdragon.chaosbits.net>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com> <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
 <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-376690670-1306793442=:8082"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-376690670-1306793442=:8082
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 30 May 2011, D. Jansen wrote:

> On Mon, May 30, 2011 at 8:45 PM,  <david@lang.hm> wrote:
> > On Mon, 30 May 2011, D. Jansen wrote:
> >
> >> On Mon, May 30, 2011 at 8:02 PM,  <david@lang.hm> wrote:
> >>>
> >>> no, you cannot just change a fsync to a barrier, in some cases the data
> >>> absolutly needs to be saved, not just ordered (remember the example of a
> >>> mail server telling the other system that the data can be deleted after a
> >>> fsync returns)
> >>
> >> I'm not really sure I why shouldn't have that choice as a user. Just
> >> because someone else could be running a mailserver on his system and
> >> configure it in a way that it doesn't behave as it should?
> >> If he really wants to do that there's really nothing we can do to stop
> >> him. I'm sure there are other ways existing kernel options can be used
> >> to make software behave different than it should. Are we going to
> >> remove them all now?
> >>
> >> The big problem is that so far only fsync existed and lots of software
> >> seemingly abuses it as an expensive write barrier. And it would really
> >> be lovely to have the choice to stop that on an opt-in basis in laptop
> >> mode.
> >
> > is the benifit of not spinning up the disk really worth the risk of loosing
> > data?
> 
> Is that a choice I can make myself? Is that a choice I make with
> laptop mode? Or is that a choice I may only make if I'm willing to
> modify and compile my own kernel?
> >
> > and should this really be a global across-the-board option?
> 
> The point is option imo.
> >
> > the problem is that most users don't know what their system is running, or
> > what effect disaling fsync would have. those that do can probably use
> > LD_PRELOAD to override fsync calls.
> 
> As we found out, they can't. But if we export barrier, I hope a
> library could wrap fsyncs into barriers. Is that the case?
> >
> > it doesn't take running a mail server, even a mail client will have the same
> > risk. If you use POP for mail (a very common option) then you download
> > messages and tell the server to delete them. if you do not really save them
> > (one fsync after they are all saved), then you can loose everything that you
> > downloaded.
> 
> Yes, I know. It's the same argument again and again. I understand not
> everybody wants this. But some do. Some prefer working 10-20% longer
> on battery (certainty) instead of possibly losing 5 % data
> (possibility) or losing all your data (possibility if you use laptop
> mode and the hard disk wakes up again and again and eventually wears
> out). That's why there's laptop mode. And this would play into laptop
> mode and prevent the hard disk from breaking down prematurely and
> saving battery.
> 

But how can you say that you are only risking 5% data loss or only risking 
your most recent data?  You can't.
fsync provides guarantees and applications take advantage of that 
guarantee and you have no way of knowing what breaking those guarantees 
will mean for all applications in the system (not without a *lot* of 
research work at least).
You may be willing to lose a few emails or a few recently modified plain 
text files or office documents. But how would you feel if that multi 
megabyte or gigabyte database that has been build up over months with your 
work suddenly became completely unrecoverable because the application 
maintaining it made some assumptions based on fsync's guarantees and those 
guarantees were suddenly broken? My guess is you wouldn't be very happy.

Some applications may only need the ordering guarantee that fsync 
provides, not the "data is safely on media" guarantee. So perhaps if a new 
barrier syscall was provided that gave applications just the lighter 
ordering guarantee, then over time those apps could transition to use it 
instead of fsync. Apps that really do need the "data is safely on media" 
guarantee would of course continue to call fsync, but the number of 
overall fsync calls in the system would decrease over time - this would 
help your battery life and we'd still have a working fsync for those apps 
that really do need it.
How does that sound?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-376690670-1306793442=:8082--
