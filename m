Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935580Ab0KQWec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:34:32 -0500
Received: from tango.0pointer.de ([85.214.72.216]:53155 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab0KQWeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:34:31 -0500
Date: Wed, 17 Nov 2010 23:34:11 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117223411.GA23983@tango.0pointer.de>
References: <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 13:08, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> So I do _not_ believe that the autogroup feature should necessarily
> mean that you cannot do other grouping decisions too. I just do think
> that the whole notion of "it got started from a tty" is actually a
> very useful thing for legacy applications, and one where it's just
> simpler to do it in the kernel than build up any extra infrastructure
> for it.
> 
> So it's not necessarily at all an "either-or" thing.

As a last update to this messy discussion, here's a commit I made to
systemd which ensures that every user session by default gets its own
cgroup in the 'cpu' hierarchy.

http://cgit.freedesktop.org/systemd/commit/?id=74fe1fe36e35a26d764f1e3119d5f6d014db573c

And here's the one that does the same to ensure that every service
systemd manages gets by default its own cgroup in the 'cpu' hierarchy.

http://cgit.freedesktop.org/systemd/commit/?id=d686d8a97bd7945af0a61504392d01a3167b576f

And finally, here's bugzilla entry for a patch I prepped for
gnome-terminal's livte which creates a subgroup for each terminal widget
shown by the same g-t instance:

https://bugzilla.gnome.org/show_bug.cgi?id=635119

With this all together we get quite a bit further than with the kernel
patch, since we also cover all kinds of services, and treat user
sessions equal to each other, and even users. (i.e. user A cannot get
double the amount of CPU time simply by spawning double the amount of
processes or double the amount of session thatn user B).

This should fix things for people with systemd and GNOME. Yes, all
others are left in the cold. Sorry for that.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
