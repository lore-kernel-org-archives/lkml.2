Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab0KQCGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:06:46 -0500
Received: from THUNK.ORG ([69.25.196.29]:56740 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab0KQCGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:06:45 -0500
Date: Tue, 16 Nov 2010 21:06:26 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117020626.GB3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
 <20101116211909.GB16589@tango.0pointer.de>
 <20101116233934.GC1568@thunk.org>
 <20101117002159.GA3184@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117002159.GA3184@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 01:21:59AM +0100, Lennart Poettering wrote:
> > I think you really want to make this be something which the
> > application can specify by default that they should start in their own
> > cgroup.  One idea might be to it to the applications menu entry:
> > 
> > http://standards.freedesktop.org/desktop-entry-spec/latest/
> > 
> > ... so there would be a new key value pair, "start_in_cgroup", that
> > would allow the user to start an application in their own cgroup.  It
> > would be up to the desktop launcher to honor that if it was present.
> 
> This is pretty much in line with what I want to do, except I want
> opt-out, not opt-in behaviour here.

That works for me.  One suggestion is that in addition to "opt-out",
it should be also possible for an application launcher file to specify
a specific cgroup name that should be used.  That would allow multiple
applications in a group to assigned to the same cgroup.

There also needs to be a way to start applications that are started
via the GNOME and KDE session manager in a specified cgroup as well.
I assume that's in your plan as well?

    	      	      	      	      - Ted
