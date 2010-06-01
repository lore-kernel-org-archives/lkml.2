Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0FAPkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:40:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308Ab0FAPj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:39:59 -0400
Date: Tue, 1 Jun 2010 08:32:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       a.beregalov@gmail.com, andi@firstfloor.org, dzickus@redhat.com,
       fejes@joco.name, g.liakhovetski@gmx.de, gthelen@google.com,
       hschauhan@nulltrace.org, hui.zhu@windriver.com, jan3sobi3ski@gmail.com,
       jay@goldhive.com, jgunthorpe@obsidianresearch.com, jkacur@redhat.com,
       joe@perches.com, kirr@mns.spb.ru, lizf@cn.fujitsu.com,
       nir.tzachar@gmail.com, rabin@rab.in, rientjes@google.com,
       roland@redhat.com, saalwaechter@gmail.com, shemminger@vyatta.com,
       tabbott@ksplice.com, u.kleine-koenig@pengutronix.de, vbendeb@google.com,
       vda.linux@googlemail.com, wuzhangjin@gmail.com, xt28@gmx.de
Subject: Re: [GIT] kbuild changes for 2.6.35
In-Reply-To: <20100531120223.GA11700@sepie.suse.cz>
Message-ID: <alpine.LFD.2.00.1006010823080.3637@i5.linux-foundation.org>
References: <20100527144459.GA14513@sepie.suse.cz> <alpine.LFD.2.00.1005300921000.4639@i5.linux-foundation.org> <20100531120223.GA11700@sepie.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Michal Marek wrote:
> > 
> > I refuse to take stuff like this. If I don't know why somethign happens, I 
> > don't want to pull it.
> 
> Sorry, here is a more complete description of the changes.
> Alternatively, would you pull a branch with the section rename stuff taken
> out?

No, the commits themselves are likely fine, although for the future it 
really would be good to make things like that more descriptive. I just 
want people to try to argue for _why_ I should do a pull, and _what_ I'm 
getting in their "please pull" thing.

It's not always necessary, and some people do it better than others. For 
an example of a really good pull request, look at the ones David Miller 
sends me for networking - they explain what's going on in the pull, so 
it's always easy to pull them because just the request makes me feel like 
David is really on top of things, and lets me have some 30'000 ft overview 
of what's going on.

At the same time, in many cases I obviously pull _without_ any kind of 
real explanation - and that tends to be especially true with maintainers 
that I've worked with for a long time, or areas that are so specialized 
that they are almost self-explanatory (let's be honest: when a filesystem 
maintainer asks me to pull their special filesystem, I'm perfectly happy 
with the overview of "30 changesets to XFS", and there's no need for much 
explanation, although a rough overview of what's been going on is always 
good to see).

So the reason I ask for explanations for kbuild is that not only have we 
had different maintainers, it's an area that affects a lot of different 
things and has historically had issues with odd architectures or old 
binutils tools etc.

So for something like that, I really do want to know what is going on, and 
then when I get a pull request with little to no explanation, and look at 
a trial pull with "gitk ORIG_HEAD.." and see no additional explanation 
there either, I just go "no, I can't pull this, I don't really know what 
it does or why it does so".

> Summary of the changes:
> - A new configuration interface (make nconfig)
> - Improvements to the other *config interfaces
> - Better modpost mismatch reporting
> - Section rename to allow for -ffunction-sections -fdata-sections
> - Untagged builds without LOCALVERSION_AUTO have a '+' appended to the
>   version string
> - Lots of minor fixes & improvements.

So I really want to know _why_ that section rename is specifically like it 
is. Why is ".data..stack" better than ".data.stack"?

			Linus
