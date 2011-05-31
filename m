Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1EaNr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:47:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52166 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1EaNrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=hhmGR3lXYcjHUtjs12NqyfxMnW9yVInw0MChzENsiXM1xjIJ2EaSg7vXEZ77fRGK2T
         86jvi0Z1sxq9QrvDp/0Dr1cqIDludHCOm+GwLgsf9b0GOWb9kMs1GzhlkvNvIfbAU1oX
         W1WpFXoepriPm65U5JDQHb9sp8syWCgpkhZpA=
MIME-Version: 1.0
In-Reply-To: <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
References: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com>
 <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm> <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
 <20110531020300.GJ2890@dhcp-172-31-194-241.cam.corp.google.com>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Tue, 31 May 2011 15:47:15 +0200
Message-ID: <BANLkTim0pFS=Fs6ga2CV5LwOs2xxbh9svA@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: "Ted Ts'o" <tytso@mit.edu>, "D. Jansen" <d.g.jansen@googlemail.com>,
        david@lang.hm, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, May 30, 2011 at 11:24:03PM +0200, D. Jansen wrote:
>> > do you really have so many fsync's going on that the disk spins up so much
>> > that you would gain 10-20% battery life?
>>
>> Yes. Every autosave in LibreOffice triggers one. And I want autosave,
>> but I want them in memory, not on disk.
>
> What on *heck* good does an autosave to memory do?  Are you afraid
> your X server is going to go poof, or OpenOffice is going to crash on
> you?
Unfortunately, yes. This happens to me regularly, e.g. roughly every
10th resume. It's a poulsbo system. ;)
Another reason is a Java extension that makes it crash happy.
(Please don't tell me now that the real fix is to fix poulsbo...)

>I can't remember the last time this has happened to me.  It's
> typically a system crash or a power loss that causes me to lose an
> OpenOffice session.

Well, good for you! Power loss didn't ever occur to me on the other
hand, at least not on my netbook.

>> > and what makes you think the extra spin-ups from fsyncs will cause your hard
>> > drive to fail significantly earlier? (if you have a hard drive with a
>> > limited number of spin-up cycles, you probably don't want to use laptop mode
>> > at all)
>>
>> Experience, see above. Also, this is well described behavior. All hard
>> disks are only designed to last a certain number of head loads and
>> unloads. Spinning up and down even less.
>
> Modern laptop drives are designed for 600,000 to a million head loads
> and unloads.  Open Office by default autosaves once every 15 minutes.
> So if you leave your system running (on battery?!?) 24x7, with open
> office open all that time, even with HDD which is only rated for 600k
> load cycles, that's 4.5 years.

Yeah, exactly what I had thought -- enabling laptop mode for the first time.
After the hard disk started to show more read errors
and almost crashed so I had to exchange it, I reconsidered.
I wish specifications would be more in conformity with reality...
Good thing I watch my smart log and caught it in time to avoid data loss.
Though I do have a solid backup routine to avoid serious issues.

> And of course, normally such a system
> is powered all the time, and the hard drive shouldn't be spinning down
> if you're on the AC mains.

Well, I use my netbook on the go mostly. I guess we just have different habits.
>
> The real fix is that applications need to be fixed to be less
> write-happy.  Firefox example, used to request a transactional update
> to a sqllite database on every web click.  Laptop mode isn't the right
> place to fix this, since if you try to stop the writes from hitting
> the disk, you'll still end up burning memory that can't be released
> until the data is written to disk.  (...)

That is another fix that everybody can benefit from. And another
reason to provide barrier support for user space.
(We have a new trojan horse!)
