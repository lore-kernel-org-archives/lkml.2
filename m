Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0KPRMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:12:55 -0500
Received: from tango.0pointer.de ([85.214.72.216]:43459 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0KPRMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:12:54 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2010 12:12:54 EST
Date: Tue, 16 Nov 2010 18:03:12 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116170312.GA19327@tango.0pointer.de>
References: <1289783580.495.58.camel@maggy.simson.net>
 <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net>
 <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 15:47, Dhaval Giani (dhaval.giani@gmail.com) wrote:

> 
> On Tue, Nov 16, 2010 at 3:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2010-11-16 at 07:02 -0700, Mike Galbraith wrote:
> >> While you can identify firefox etc,
> >> it's not being done, and requires identifying every application.  Heck,
> >> cgroups is built in, but userspace doesn't even mount.  Nothing but
> >> nothing uses cgroups.
> >
> > The yet another init rewrite called systemd is supposedly cgroup happy..
> > No idea if its going to be useful though, I doubt its going to have an
> > effect on me launching a konsole or the like, or screen creating a bunch
> > of ttys.
> 
> systemd uses cgroups only for process tracking. No resource
> management. Though afaik, Lennart has some plans of doing resource
> management using systemd. I wonder how autogroups will interact with
> systemd in that case.

systemd already creates a named cgroup for each user who logs in and each
session inside it. That's implemented via pam_systemd, which is enabled
in all distros doing systemd. We create those groups right now only in
the named "systemd" hierarchy, but iiuc then simply doing the same in
the "cpu" hierarchy would have the exact same behaviour as this patch,
but actually is based on a sane definition of what a session is.

Binding something like this to TTYs is just backwards. No graphical
session has a TTY attached anymore. And there might be multiple TTYs
used in the same session. 

I really wonder why logic like this should live in kernel space at all,
since a) the kernel has no real notion of a session, except audit and b)
this is policy and as soon as people have this kind of group then they
probably want other kind of autogrouping as well for the other
controllers, which hence means userspace is a better, and configurable
place for this.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
