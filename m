Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab1ETRqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:46:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ETRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:46:10 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=TwWXrjo8ZJIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WqbCKyZ2QD-ZYXC-AD8A:9 a=3YYeNgJ6jl8wf5MBUTwA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: Steven Rostedt <rostedt@goodmis.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Darren Hart <dvhart@linux.intel.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <201105201910.13095.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	 <1305907458.1465.23.camel@gandalf.stny.rr.com>
	 <1305907896.1465.27.camel@gandalf.stny.rr.com>
	 <201105201910.13095.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 May 2011 13:46:09 -0400
Message-ID: <1305913569.1465.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 19:10 +0200, Toralf Förster wrote:
> Steven Rostedt wrote at 18:11:36
> > > Wait! This is where we need the WARN_ON_SMP(), do we have that patch in?
> > > 
> > > I think UML is UP, and that spin_is_locked() will always return false.
> > 
> > Could you apply these patches:
> > 
> > 2092e6be WARN_ON_SMP(): Allow use in if() statements on UP
> > 29096202 futex: Fix WARN_ON() test for UP
> > 
> > On top of this commit, and see if the problem goes away. What could have
> > happened, is that you have two bugs, with one of them fixed. If the git
> > bisect stumbled on this bug, it will show this one, even though later
> > on, this code was fixed. If you apply the above two patches and it works
> > again, then this isn't the bug you are looking for.
> > 
> > -- Steve
> Right - applying those 2 commits on top of v2.6.38-rc8-1-g2e12978 works - now 
> the issue is away.
> 
> And yes - now I've to look for the other of two bugs, which was introduced 
> between the tags v2.6.38 and v2.6.39, I think.

Another thing you could do is checkout 29096202 and see if it works. If
it does, you can base that as your "git bisect good" and you should not
be affected by this bug again.

-- Steve


