Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2BZCZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 21:25:25 -0500
Received: from mx.treblig.org ([80.68.94.177]:57010 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2BZCZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 21:25:24 -0500
X-Greylist: delayed 1615 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Feb 2012 21:25:24 EST
Date: Sun, 26 Feb 2012 01:58:20 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Jidong Xiao <jidong.xiao@gmail.com>, david@lang.hm,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120226015820.GB18931@gallifrey>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <4F4661D6.7030809@gmail.com>
 <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
 <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
 <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
 <20120224162109.1bbf157b@redhat.com>
 <20120225150940.GA3719@localhost>
 <4F497782.3060902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F497782.3060902@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 01:44:51 up 21 days, 12:37,  1 user,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mauro Carvalho Chehab (mchehab@redhat.com) wrote:
> Em 25-02-2012 13:10, Eduard - Gabriel Munteanu escreveu:
> > On Fri, Feb 24, 2012 at 04:21:09PM -0200, Mauro Carvalho Chehab wrote:
> >> Moving a buggy driver to userspace won't fix the bug. You're just moving
> >> it from one place to another place. Also, the code will likely require changes
> >> to work on userspace, so, the chances are that you're actually introducing more
> >> bugs.
> > 

<snip>

> >> That's said, there are much more eyes inspecting the kernel sources than on any 
> >> other userspace project. So, the risk of a bad code to be inserted unnoticed at
> >> the Linux kernel is degrees of magnitude lower than on an userspace driver.
> > 
> > Those much more eyes have already missed important bugs in the past.
> 
> Yes, nobody is perfect. But the probability that something passes on a 4000+ people
> review is lower than the probability of a bug on a piece of code where just one 
> or two people are looking on it.

That there are 4000+ people reading a driver is a big assumption; for common
drivers I'd agree - one problem though is there are a lot of drivers for obscure
hardware or old/dead hardware/protocols that frankly near to nobody cares about.

Very few people read those drivers; yet sometimes they get built and distributed
and someone then finds that since no one has looked at them they're full of holes,
and given a malicious USB device for example, you can suddenly create one of these
devices that only 3 people have bothered to read the source to - 5 years ago.
(The Econet security bug recently would be an example of that).

There is a line which says that things that really aren't used
just shouldn't be built; but then there are things that are only used
by a few people, and then ones only used by a few organisations - and
it gets very difficult to say at what point you say just turn it off.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
