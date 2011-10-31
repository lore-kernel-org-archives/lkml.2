Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1JaQkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:40:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31799 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1JaQkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:40:08 -0400
MIME-Version: 1.0
Message-ID: <ef778e79-72d0-4c58-99e8-3b36d85fa30d@default>
Date: Mon, 31 Oct 2011 09:38:12 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default
 20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EAECEFD.00F5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)

Hi Kame --

Thanks for your reply and for your earlier reviews of frontswap,
and my apologies that I accidentally left you off of the Cc list \
for the basenote of this git-pull request.

> I don't have heavy concerns to the codes itself but this process as bypassing -mm
> or linux-next seems ugly.

First, frontswap IS in linux-next and it has been since June 3
and v11 has been in linux-next since September 23.  This
is stated in the base git-pull request.
 
> Why bypass -mm tree ?
> 
> I think you planned to merge this via -mm tree and, then, posted patches
> to linux-mm with CC -mm guys.

Hmmm... the mm process is not clear or well-documented.
I am a relative newbie here.  Linus has repeatedly spoken
of ensuring that code is in linux-next, and there is no
(last I checked) current -mm git tree.  I was aware that
the mm tree still existed, but thought it was for shaking
out major features, not for adding a handful of hooks.
I was aware that akpm's blessing was highly desirable,
but his (offlist) reply was essentially "I'm not interested,
I don't have time to deal with this, and I don't think anyone
will use it."  I explained about all the users (many of whom
have replied to this thread to support frontswap), but got
no further reply.  I was advised by several people that, in
the case of disagreement, Linus will decide, so I pushed
forward.  This is the same as the process I used for
cleancache, which Linus merged.

I have been instructed offlist and onlist that this was a big
mistake, that it appears that I am subverting the process,
and that I am probably insulting akpm.  If so, I am
truly sorry and would be happy to take instruction
on how to proceed correctly.  However, in turn, I hope
that those driving the process aren't blocking useful
code simply due to lack of time.

> I think you posted 2011/09/16 at the last time, v10. But no further submission
> to gather acks/reviews from Mel, Johannes, Andrew, Hugh etc.. and no inclusion
> request to -mm or -next. _AND_, IIUC, at v10, the number of posted pathces was 6.
> Why now 8 ? Just because it's simple changes ?

See https://lkml.org/lkml/2011/9/21/373.  Konrad Wilk
helped me to reorganize the patches (closer to what you
suggested I think), but there were no code changes between
v10 and v11, just dividing up the patches differently
as Konrad thought there should be more smaller commits.
So no code change between v10 and v11 but the number of
patches went from 6 to 8.

My last line in that post should also make it clear that
I thought I was done and ready for the 3.2 window, so there
was no evil intent on my part to subvert a process.
It would have been nice if someone had told me there
were uncompleted steps in the -mm process or, even better,
pointed me to a (non-existent?) document where I could see
for myself if I was missing steps!

So... now what?

Thanks,
Dan

P.S. It appears that this excerpt from the LWN KS2011 report
might be related to the problem?

  "Andrew complained about the acceptance of entirely new
   features into the kernel. Those features often land on
   his doorstep without much justification, forcing him to
   ask the developers to explain their motivations. The kernel
   community, he complained, is not supporting him well. Who
   can tell him if a given patch makes sense? Mistakes have
   been made in the past; bad features have been merged and
   good stuff has been lost. How, he asked, can he find
   people who know better about the desirability of
   specific patches?"
