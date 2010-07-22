Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0GVXXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:23:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0GVXXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:23:04 -0400
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Jan Safranek <jsafrane@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20100722231401.GA11538@suse.de>
References: <20100722182638.GA12712@kroah.com>
	 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	 <20100722183614.GA5443@suse.de> <20100722193741.GA2688@redhat.com>
	 <20100722211856.GA1297@suse.de>
	 <AANLkTinFQtwrCC82T9KlKskDV8fn-zYgimyH2wguHkqY@mail.gmail.com>
	 <20100722231401.GA11538@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 01:23:01 +0200
Message-ID: <1279840981.2036.4.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 16:14 -0700, Greg KH wrote:
> On Fri, Jul 23, 2010 at 01:08:12AM +0200, Kay Sievers wrote:
> > On Thu, Jul 22, 2010 at 23:18, Greg KH <gregkh@suse.de> wrote:
> > >> For my testing I now always use /cgroup/ and create directories under it
> > >> /cgroup/blkio /cgroup/cpu etc and mount controllers on respective
> > >> directories.
> > >
> > > Lennart and Kay, is this what systemd is doing?  I really don't think we
> > > should be adding a root /cgroup/ mount point to the system for something
> > > like this.
> > 
> > Already solved. Systemd always mounts an empty tmpfs at the 'cgroup'
> > mountpoint, and stuff is free to create subdirs there. Systemd itself
> > mount 'systemd' there.
> 
> Ah, that makes it easier.  Paul and Vivek, any objection to this patch
> going in now?

Just to get an idea, here is the current output on a systemd system:

/dev/sda3 /home/kay/work ext3 rw,noatime,errors=continue,user_xattr,acl,barrier=0,data=writeback 0 0
devtmpfs /dev devtmpfs rw,relatime,size=1965252k,nr_inodes=491313,mode=755 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
tmpfs /cgroup tmpfs rw,nosuid,nodev,noexec,relatime,mode=755 0 0
cgroup /cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
systemd-1 /dev/mqueue autofs rw,relatime,fd=15,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
systemd-1 /sys/kernel/security autofs rw,relatime,fd=16,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=17,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
systemd-1 /sys/kernel/debug autofs rw,relatime,fd=18,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
systemd-1 /dev/hugepages autofs rw,relatime,fd=19,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
tmpfs /var/run tmpfs rw,relatime,mode=755 0 0
tmpfs /var/lock tmpfs rw,relatime,mode=775,gid=54 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
gvfs-fuse-daemon /home/kay/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,relatime,user_id=2702,group_id=100 0 0

Kay

