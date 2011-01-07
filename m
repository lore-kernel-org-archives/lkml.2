Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1AGI3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:29:32 -0500
Received: from kramwerk.de ([62.75.162.77]:42170 "EHLO mail.kramwerk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1AGI3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:29:30 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
From: Florian Kriener <florian@kriener.org>
To: Nick Piggin <npiggin@gmail.com>
Subject: Re: BUG in fs/inode.c:429
Date: Fri, 7 Jan 2011 09:29:28 +0100
User-Agent: KMail
References: <201101061735.40060.florian@kriener.org> <AANLkTi=QDTt=QYwf3+jr0jWd6D3HiBNaOh_sOG6hey=s@mail.gmail.com>
In-Reply-To: <AANLkTi=QDTt=QYwf3+jr0jWd6D3HiBNaOh_sOG6hey=s@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070929.28672.florian@kriener.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 January 2011 01:44:49 you wrote:
> On Fri, Jan 7, 2011 at 3:35 AM, Florian Kriener <florian@kriener.org> 
> > [ 4626.750273] ------------[ cut here ]------------
> > [ 4626.750314] kernel BUG at
> > /build/buildd-linux-2.6_2.6.37~rc7-1~experimental.1-amd64-
> > Mw4Tor/linux-2.6-2.6.37~rc7/debian/build/source_amd64_none/fs/inod
> > e.c:429!
> 
> Is this an unpatched kernel? ie.
> BUG_ON(!list_empty(&inode->i_data.private_list));

I checked, and yes, that's the line.
 
> > I am using 2.6.37-rc7 from Debian experimental and all my
> > filesystems are ext4 except for /boot, which is ext2 (and /tmp is
> > tmpfs).
> 
> Definitely no other filesystems? Too bad frame pointers are turned
> off, but it seems perhaps default evict_inode is being used, which
> doesn't do invalidate_inode_buffers(). ext2/3/4/fat/udf all seem to
> do the right thing here, though.

% mount
/dev/mapper/nanuk-root on / type ext4 (rw,noatime,errors=remount-ro,acl,commit=0)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
/dev/sda1 on /boot type ext2 (rw,noatime)
tempfs on /tmp type tmpfs (rw,noatime,mode=1777)
/dev/mapper/nanuk-home on /home type ext4 (rw,noatime,acl,commit=0)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)

and that's all. I have an external hard drive, that is not shown above, but
its ext4 there too.
 
> If it's happening semi frequently, could you compile a vanilla 2.6.37
> with the same .config, just turn on frame pointers, and report if it
> happens again?

I'll do that. But I don't know how to turn frame pointers on. Is that a config
option? I only know of the -fomit-frame-pointers gcc option. If I understand
correctly that would be a small to medium performance hit, am I right?

> Dumping the inode->i_ops symbol name before going BUG in fact
> might be helpful too.

Again, I'll do that if you tell me how to.

Sorry for beeing such a noop.

Thanks,
Flo.
