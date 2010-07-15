Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0GOHXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 03:23:53 -0400
Received: from mail.lang.hm ([64.81.33.126]:33248 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab0GOHXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 03:23:52 -0400
Date: Thu, 15 Jul 2010 00:23:28 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Newall <davidn@davidnewall.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Marcin Letyns <mletyns@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stable? quality assurance?
In-Reply-To: <4C3B73D7.8050802@davidnewall.com>
Message-ID: <alpine.DEB.2.00.1007142358160.14221@asgard.lang.hm>
References: <201007110918.42120.Martin@lichtvoll.de> <20100711131640.GA3503@thunk.org> <4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <4C3B3B39.2000809@davidnewall.com> <4C3B585A.6090106@s5r6.in-berlin.de>
 <4C3B73D7.8050802@davidnewall.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, David Newall wrote:

> (Segue to a problem which follows from calling bleeding-edge kernels 
> "stable".)
>
> When reporting bugs, the first response is often, "we're not interested in 
> such an old kernel; try it with the latest."  That's not hugely useful when 
> the latest kernels are not suitable for production use.  If kernels weren't 
> marked stable until they had earned the moniker, for example 2.6.27, then the 
> expectation of developers and of users would be consistent: developers could 
> expect users to try it again with latest stable kernel, and users could 
> reasonably expect that trying it wouldn't break their system.

2.6.27 didn't get declared 'stable' because it had very few bugs, it was 
declared 'stable' because someone volunteered to maintain it longer and 
back-port patches to it long past the normal process.

2.6.32 got declared 'long-term stable' before 2.6.33 was released, again 
not because it was especially good, but because it didn't appear to be 
especially bad and several distros were shipping kernels based on it, so 
again someone volunteered (or was volunteered by the distro that pays 
their paycheck) to badk-port patches to it longer.

I have been running kernel.org kernels on my production systems for >13 
years. I am _very_ short of time, so I generally don't get a chance to 
test the -rc kernels (once in a while I do get a chance to do so on my 
laptop). What I do is every 2-3 kernel releases I wait a couple days after 
the kernel release to see if there are show-stopper bugs, and if nothing 
shows up (which is the common case for the last several years) I compile a 
kernel and load it on machines in my lab. I try to have a selection of 
machines that match the systems I have in production in what I have found 
are the 'important' ways (a defintition that changes once in a while when 
I find something that should 'just work' that doesn't ;-). This primarily 
includes systems with all the network card types and Raid card types that 
I use in production, but now also includes a machine with a SSD (after I 
found a bug that only affected that combination)

if my lab machiens don't crash immediatly, I leave them running (usually 
not even stress testing them, again lack of time) for a week or so, then I 
put the new kernel on my development machiens, wait a few days, then put 
them on QA machines, wait a few days, then put them in production. I have 
the old kernel around so that I can re-boot into it if needed.

This tends to work very well for me. It's not perfect and every couple of 
cycles I run into grief and have to report a bug to the kernel list. 
Usually I find it before I get into production, but I have run into cases 
that got all the way into production before I found a problem.

with the 'new' -stable series, I generally wait until at least 2.6.x.1 is 
released before I consider it ready to go anywhere outside my lab (I'll 
still install the 2.6.x kernel in the lab, but I'll wait for the 
additional testing that comes with the .1 stable kernels before moving it 
on)

I don't go through this entire process with the later -stable kernels, If 
I'm already running 2.6.x and there is a 2.6.x.y released that contains 
fixes that look like they are relavent to the configuration that I run 
(which lets out the majority of changes, I do fairly minimal kernel 
configs) I will just test it in the lab to do a smoke test, then schedule 
a rollout through the rest of my network. If there are no problems before 
I get permission to deploy to production I put it on half my boxes, 
failover to them, then wait a little bit (a day to a week) before 
upgrading the backups.

this writeup actually makes it sound like I spend a lot of time working 
with kernels, but I really don't. I'll spend couple half days twice a year 
on testing, and then additional time rolling it out to the 150+ clusters 
of servers I have in place. If you can't spend at least this much time on 
the kernel you are probably better off just running your distro kernel, 
but even there you really should do a very similar set of tests on it's 
kernel releases.

There's another department in my company that uses distro kernels (big 
name distro, but I will avoid flames by not naming names) without the 
testing routine that I use and my track record for stability compares 
favorablely to theirs over the last 7 years or so (they haven't been 
running linux as long as I have, so we can't go back as far ;-) They also 
do more updates than I do simply because they can't as easily look at the 
kernel release and decide it doesn't apply to them.

David Lang
