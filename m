Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1E3Sq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:46:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:56237 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab1E3SqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:46:25 -0400
Date: Mon, 30 May 2011 11:45:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: Theodore Tso <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com> <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
 <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
 <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, D. Jansen wrote:

> On Mon, May 30, 2011 at 8:02 PM,  <david@lang.hm> wrote:
>>
>> no, you cannot just change a fsync to a barrier, in some cases the data
>> absolutly needs to be saved, not just ordered (remember the example of a
>> mail server telling the other system that the data can be deleted after a
>> fsync returns)
>
> I'm not really sure I why shouldn't have that choice as a user. Just
> because someone else could be running a mailserver on his system and
> configure it in a way that it doesn't behave as it should?
> If he really wants to do that there's really nothing we can do to stop
> him. I'm sure there are other ways existing kernel options can be used
> to make software behave different than it should. Are we going to
> remove them all now?
>
> The big problem is that so far only fsync existed and lots of software
> seemingly abuses it as an expensive write barrier. And it would really
> be lovely to have the choice to stop that on an opt-in basis in laptop
> mode.

is the benifit of not spinning up the disk really worth the risk of 
loosing data?

and should this really be a global across-the-board option?

the problem is that most users don't know what their system is running, or 
what effect disaling fsync would have. those that do can probably use 
LD_PRELOAD to override fsync calls.

it doesn't take running a mail server, even a mail client will have the 
same risk. If you use POP for mail (a very common option) then you 
download messages and tell the server to delete them. if you do not really 
save them (one fsync after they are all saved), then you can loose 
everything that you downloaded.

David Lang
