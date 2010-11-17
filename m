Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631Ab0KQWqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:46:09 -0500
Received: from tango.0pointer.de ([85.214.72.216]:33675 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935568Ab0KQWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:46:07 -0500
Date: Wed, 17 Nov 2010 23:45:47 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117224547.GA26008@tango.0pointer.de>
References: <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
 <20101117223411.GA23983@tango.0pointer.de>
 <1290033435.2109.1282.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290033435.2109.1282.camel@laptop>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17.11.10 23:37, Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:

> 
> On Wed, 2010-11-17 at 23:34 +0100, Lennart Poettering wrote:
> > 
> > This should fix things for people with systemd and GNOME. Yes, all
> > others are left in the cold. Sorry for that. 
> 
> Is there an easy opt out for that, other than booting a CONFIG_CGROUP=n
> kernel?

systemd relies on CONFIG_CGROUP=y, since it useses it for service
management. It creates its own name=systemd hierarchy for that with no
controllers attached. If you turn that off, then systemd will refuse to
boot. However, it does not rely on any of the controllers, and hence you
are welcome to disable all cgroup controlls and systemd won't complain.

If you want to disable the automatic creation of groups in the 'cpu'
hierarchy for user sessions then you can tell pam_systemd that by passing
"controllers=" on the PAM config line. ("controllers=cpu" is the implied
default.)

There's currently no global option to disable the same logic in systemd
when it creates 'cpu' cgroups for the various services it runs. However,
you can disable that individually with "ControlGroups=cpu:/" in the
.service files. I will now add a global option as well.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
