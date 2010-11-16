Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0KPTNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:13:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0KPTNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:13:12 -0500
Date: Tue, 16 Nov 2010 14:12:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Stephen Clark <sclark46@earthlink.net>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116191233.GE13092@redhat.com>
References: <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <4CE2D41D.3070609@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2D41D.3070609@earthlink.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 01:57:33PM -0500, Stephen Clark wrote:
> On 11/16/2010 01:16 PM, Lennart Poettering wrote:
> >On Tue, 16.11.10 09:11, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> >
> >>On Tue, Nov 16, 2010 at 9:03 AM, Lennart Poettering
> >><mzxreary@0pointer.de>  wrote:
> >>>Binding something like this to TTYs is just backwards.
> >>Numbers talk, bullshit walks.
> >>
> >>The numbers have been quoted. The clear interactive behavior has been seen.
> >Here's my super-complex patch btw, to achieve exactly the same thing
> >from userspace without involving any kernel or systemd patching and
> >kernel-side logic. Simply edit your own ~/.bashrc and add this to the end:
> >
> >   if [ "$PS1" ] ; then
> >           mkdir -m 0700 /sys/fs/cgroup/cpu/user/$$
> >           echo $$>  /sys/fs/cgroup/cpu/user/$$/tasks
> >   fi
> >
> >Then, as the superuser do this:
> >
> >   mount -t cgroup cgroup /sys/fs/cgroup/cpu -o cpu
> >   mkdir -m 0777 /sys/fs/cgroup/cpu/user
> >
> >Done. Same effect. However: not crazy.
> >
> >I am not sure I myself will find the time to prep some 'numbers' for
> >you. They'd be the same as with the kernel patch anyway. But I am sure
> >somebody else will do it for you...
> >
> >Lennart
> >
> So you have tested this and have a nice demo and numbers to back it up?

I just modified my .bashrc and for my each ssh session, it seems to
be working fine and creating a cgroup as soon as I ssh into the box.

Just that it will need little modification to reap the group automatically
when shell exits.

Thanks
Vivek
