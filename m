Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab2CEPrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:47:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51976 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751014Ab2CEPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:47:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18W53dv7F4W77ovDyIAHv+SNDC/bSryRMn/amGcDw
	KWdmKxg90us+vG
Message-ID: <1330962421.7368.69.camel@marge.simpson.net>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Mike Galbraith <efault@gmx.de>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Mon, 05 Mar 2012 16:47:01 +0100
In-Reply-To: <20120305124310.GD10929@tango.0pointer.de>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	 <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
	 <20120301210213.GF13533@redhat.com>
	 <1330639448.7414.97.camel@marge.simpson.net>
	 <20120305124310.GD10929@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 13:43 +0100, Lennart Poettering wrote: 
> On Thu, 01.03.12 23:04, Mike Galbraith (efault@gmx.de) wrote:
> 
> > 
> > On Thu, 2012-03-01 at 16:02 -0500, Vivek Goyal wrote: 
> > > On Thu, Mar 01, 2012 at 09:26:43PM +0100, Mike Galbraith wrote:
> > 
> > > > Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> > > > over sysvinits job afaiui, what does that have to do with cgroups?
> > > 
> > > I think they were using it to track all the children forked by a service
> > > and cleanup all of them if need be. So they just need it for logical
> > > grouping functionality and don't require any controllers as such.
> > 
> > Hm.  Controllers are perhaps not required, but cpu controller was
> > configured and used without consent.  I didn't receive an offer.
> 
> Just set DefaultControllers= in /etc/systemd/system.conf to an empty
> string and systemd will not make use of any hierarchy beyond its private
> name=systemd named hierarchy.

I updated my laptop to openSUSE 12.1 over the weekend, so tried it.  It
didn't work, so I tried setting JoinControllers= as well.  That split up
cpu and cpuacct, but didn't stop cpu from being used.  I then moved both
system.conf and user.conf to /etc/systemd/save, and got the original
setup back.. not surprising given everything was commented out in both
files to begin with.  The little bugger is stubborn.

maggy:/etc/systemd # mount|grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/ns type cgroup (rw,nosuid,nodev,noexec,relatime,ns)
cgroup on /sys/fs/cgroup/cpu type cgroup (rw,nosuid,nodev,noexec,relatime,cpu)
cgroup on /sys/fs/cgroup/cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
maggy:/etc/systemd # cat /sys/fs/cgroup/cpu/tasks|wc -l
262
maggy:/etc/systemd # cat system.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
# See systemd.conf(5) for details

[Manager]
#LogLevel=info
#LogTarget=syslog-or-kmsg
#LogColor=yes
#LogLocation=no
#DumpCore=yes
#CrashShell=no
#ShowStatus=yes
#SysVConsole=yes
#CrashChVT=1
#CPUAffinity=1 2
#MountAuto=yes
#SwapAuto=yes
DefaultControllers=
#DefaultStandardOutput=syslog
#DefaultStandardError=inherit
JoinControllers=
maggy:/etc/systemd #

reboot...

maggy:/etc/systemd # mount|grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/ns type cgroup (rw,nosuid,nodev,noexec,relatime,ns)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
maggy:/etc/systemd # cat /sys/fs/cgroup/cpu/tasks|wc -l
146
maggy:/etc/systemd # ls
save  system  systemd-logind.conf  user
maggy:/etc/systemd #


