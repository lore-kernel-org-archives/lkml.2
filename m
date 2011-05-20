Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935368Ab1ETRKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:10:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50750 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756426Ab1ETRKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:10:23 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18qmg9Ti68qqv/cGxZ/2U8nf77dbYJKOGXAtA1Nfa
	i+POFfJnWVlaTl
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Fri, 20 May 2011 19:10:12 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: Darren Hart <dvhart@linux.intel.com>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <1305907458.1465.23.camel@gandalf.stny.rr.com> <1305907896.1465.27.camel@gandalf.stny.rr.com>
In-Reply-To: <1305907896.1465.27.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105201910.13095.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt wrote at 18:11:36
> > Wait! This is where we need the WARN_ON_SMP(), do we have that patch in?
> > 
> > I think UML is UP, and that spin_is_locked() will always return false.
> 
> Could you apply these patches:
> 
> 2092e6be WARN_ON_SMP(): Allow use in if() statements on UP
> 29096202 futex: Fix WARN_ON() test for UP
> 
> On top of this commit, and see if the problem goes away. What could have
> happened, is that you have two bugs, with one of them fixed. If the git
> bisect stumbled on this bug, it will show this one, even though later
> on, this code was fixed. If you apply the above two patches and it works
> again, then this isn't the bug you are looking for.
> 
> -- Steve
Right - applying those 2 commits on top of v2.6.38-rc8-1-g2e12978 works - now 
the issue is away.

And yes - now I've to look for the other of two bugs, which was introduced 
between the tags v2.6.38 and v2.6.39, I think.

Is there's an easy way to check, whether a given checked out git tree contains 
a specific commit id ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
