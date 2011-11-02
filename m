Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1KBBP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:15:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60907 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1KBBP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:15:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 2 Nov 2011 10:14:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Message-Id: <20111102101414.457e0a08.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <f62e02cd-fa41-44e8-8090-efe2ef052f64@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
	<ef778e79-72d0-4c58-99e8-3b36d85fa30d@default
 20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
	<f62e02cd-fa41-44e8-8090-efe2ef052f64@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 08:25:38 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> >   - At discussing an fujitsu user support guy (just now), he asked
> >     'why it's not designed as device driver ?"
> >     I couldn't answered.
> > 
> >     So, I have small concerns with frontswap.ops ABI design.
> >     Do we need ABI and other modules should be pluggable ?
> >     Can frontswap be implemented as something like
> > 
> >     # setup frontswap via device-mapper or some.
> >     # swapon /dev/frontswap
> >     ?
> >     It seems required hooks are just before/after read/write swap device.
> >     other hooks can be implemented in notifier..no ?
> 
> A good question, and it is answered in FAQ #4 included in
> the patchset (Documentation/vm/frontswap.txt).  The short
> answer is that the tmem ABI/API used by frontswap is
> intentionally very very dynamic -- ANY attempt to put
> a page into it can be rejected by the backend.  This is
> not possible with block I/O or swap, at least without
> a massive rewrite.  And this dynamic capability is the
> key to supporting the many users that frontswap supports.
> 
Hmm.

> By the way, what your fujitsu user support guy suggests is
> exactly what zram does.  The author of zram (Nitin Gupta)
> agrees that frontswap has many advantages over zram,
> see https://lkml.org/lkml/2011/10/28/8 and he supports
> merging frontswap.  And Ed Tomlinson, a current user
> of zram says that he would use frontswap instead of
> zram: https://lkml.org/lkml/2011/10/29/53 
> 
> Kame, can I add you to the list of people who support
> merging frontswap, assuming more good performance numbers
> are posted?
> 
Before answer, let me explain my attitude to this project.

As hobby, I like this kind of work which allows me to imagine what kind
of new fancy features it will allow us. Then, I reviewed patches.

As people who sells enterprise system and support, I can't recommend this
to our customers. IIUC, cleancache/frontswap/zcache hides its avaiable
resources from user's view and making the system performance unvisible and
not-predictable. That's one of the reason why I asksed whether or not
you have plans to make frontswap(cleancache) cgroup aware.
(Hmm, but at making a product which offers best-effort-performance to customers,
 this project may make sense. But I am not very interested in best-effort
 service very much.)

I wonder if there are 'static size simple victim cache per cgroup' project
under frontswap/cleancache and it helps all user's workload isolation
even if there is no VM or zcache, tmem.  It sounds wonderful.

So, I'd like to ask whether you have any enhancement plans in future ?
rather than 'current' peformance. The reason I hesitate to say "Okay!",
is that I can't see enterprise usage of this, a feature which cannot
be controlled by admins and make perfomrance prediction difficult in busy system.

Thanks,
-Kame

