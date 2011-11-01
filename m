Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1KAP1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:27:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28145 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1KAP1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:27:00 -0400
MIME-Version: 1.0
Message-ID: <f62e02cd-fa41-44e8-8090-efe2ef052f64@default>
Date: Tue, 1 Nov 2011 08:25:38 -0700 (PDT)
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
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
 <ef778e79-72d0-4c58-99e8-3b36d85fa30d@default
 20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020205.4EB00F79.0215,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On Mon, 31 Oct 2011 09:38:12 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > I think you planned to merge this via -mm tree and, then, posted patches
> > > to linux-mm with CC -mm guys.
> >
> > Hmmm... the mm process is not clear or well-documented.
> 
> not complicated to me.
> 
> post -> akpm's -mm tree -> mainline.
> 
> But your tree seems to be in -mm via linux-next. Hmm, complicated ;(
> I'm sorry I didn't notice frontswap.c was there....

Am I correct that the "post -> akpm's -mm tree" part requires
akpm to personally merge the posted linux-mm patches into
his -mm tree?  So no git tree?  I guess I didn't understand
that which is why I never posted v11 and just put it into my
git tree which was being pulled into linux-next.

Anyway, I am learning now... thanks. 

> > > I think you posted 2011/09/16 at the last time, v10. But no further submission
> > > to gather acks/reviews from Mel, Johannes, Andrew, Hugh etc.. and no inclusion
> > > request to -mm or -next. _AND_, IIUC, at v10, the number of posted pathces was 6.
> > > Why now 8 ? Just because it's simple changes ?
> >
> > See https://lkml.org/lkml/2011/9/21/373.  Konrad Wilk
> > helped me to reorganize the patches (closer to what you
> > suggested I think), but there were no code changes between
> > v10 and v11, just dividing up the patches differently
> > as Konrad thought there should be more smaller commits.
> > So no code change between v10 and v11 but the number of
> > patches went from 6 to 8.
> >
> > My last line in that post should also make it clear that
> > I thought I was done and ready for the 3.2 window, so there
> > was no evil intent on my part to subvert a process.
> > It would have been nice if someone had told me there
> > were uncompleted steps in the -mm process or, even better,
> > pointed me to a (non-existent?) document where I could see
> > for myself if I was missing steps!
> >
> > So... now what?
> 
> As far as I know, patches for memory management should go through akpm's tree.
> And most of developpers in that area see that tree.
> Now, your tree goes through linux-next. It complicates the problem.
> 
> When a patch goes through -mm tree, its justification is already checked by
> , at least, akpm. And while in -mm tree, other developpers checks it and
> some improvements are done there.
> 
> Now, you tries to push patches via linux-next and your
> justification for patches is checked _now_. That's what happens.
> It's not complicated. I think other linux-next patches are checked
> its justification at pull request.

OK, I will then coordinate with sfr to remove it from the linux-next
tree when (if?) akpm puts the patchset into the -mm tree.  But
since very few linux-mm experts had responded to previous postings
of the frontswap patchset, I am glad to have a much wider audience
to discuss it now because of the lkml git-pull request.

> So, all your work will be to convice people that this feature is
> necessary and not-intrusive, here.
> 
> From my point of view,
> 
>   - I have no concerns with performance cost. But, at the same time,
>     I want to see performance improvement numbers.

There are numbers published for Xen.  I have received
the feedback that benchmarks are needed for zcache also.

>   - At discussing an fujitsu user support guy (just now), he asked
>     'why it's not designed as device driver ?"
>     I couldn't answered.
> 
>     So, I have small concerns with frontswap.ops ABI design.
>     Do we need ABI and other modules should be pluggable ?
>     Can frontswap be implemented as something like
> 
>     # setup frontswap via device-mapper or some.
>     # swapon /dev/frontswap
>     ?
>     It seems required hooks are just before/after read/write swap device.
>     other hooks can be implemented in notifier..no ?

A good question, and it is answered in FAQ #4 included in
the patchset (Documentation/vm/frontswap.txt).  The short
answer is that the tmem ABI/API used by frontswap is
intentionally very very dynamic -- ANY attempt to put
a page into it can be rejected by the backend.  This is
not possible with block I/O or swap, at least without
a massive rewrite.  And this dynamic capability is the
key to supporting the many users that frontswap supports.

By the way, what your fujitsu user support guy suggests is
exactly what zram does.  The author of zram (Nitin Gupta)
agrees that frontswap has many advantages over zram,
see https://lkml.org/lkml/2011/10/28/8 and he supports
merging frontswap.  And Ed Tomlinson, a current user
of zram says that he would use frontswap instead of
zram: https://lkml.org/lkml/2011/10/29/53 

Kame, can I add you to the list of people who support
merging frontswap, assuming more good performance numbers
are posted?

Thanks,
Dan
