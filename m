Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0KVImQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:42:16 -0500
Received: from tomasu.net ([64.85.170.234]:48152 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0KVImP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:42:15 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Avi Kivity <avi@redhat.com>
Subject: Re: autofs4 hang in 2.6.37-rc1
Date: Mon, 22 Nov 2010 01:42:07 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3-nofp+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: Ian Kent <raven@themaw.net>, Arnd Bergmann <arnd@arndb.de>,
        autofs@linux.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4CDFDC2B.6040205@redhat.com> <1289784674.3248.11.camel@localhost> <4CE0F713.8090503@redhat.com>
In-Reply-To: <4CE0F713.8090503@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011220142.08110.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 15, 2010, Avi Kivity wrote:
> On 11/15/2010 03:31 AM, Ian Kent wrote:
> > >  If the ioctl can sleep for multiple seconds, the mutex should
> > >  indeed be dropped, and that would be safe because we used to
> > >  do the same with the BKL.
> > >  
> > >  The question is why this would sleep for more than 120 seconds.
> > 
> > umount against a server that isn't responding can easily take more than
> > 2 minutes.
> 
> Well, in my setup, the server should be responding.

Same as in mine. Server's up, but automount is locking up solid. trying to 
access the share, or links pointing to anything on it also lock up and can't 
be killed.

[ 5520.863130] INFO: task automount:1491 blocked for more than 120 seconds.
[ 5520.863139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 5520.863145] automount     D 0000000000000001     0  1491      1 0x00000000
[ 5520.863157]  ffff880137f5fdc8 0000000000000086 ffff880137f5fd48 
0000000000000086
[ 5520.863172]  ffff8800379efd78 ffff880137f5e000 ffff880137f5e000 ffff88013f1c06a0
[ 5520.863184]  ffff880137f5e010 ffff88013f1c0960 ffff880137f5ffd8 ffff880137f5ffd8
[ 5520.863197] Call Trace:
[ 5520.863214]  [<ffffffff81038541>] ? get_parent_ip+0x11/0x50
[ 5520.863232]  [<ffffffff813914ea>] __mutex_lock_slowpath+0x11a/0x1e0
[ 5520.863242]  [<ffffffff813962fd>] ? sub_preempt_count+0x9d/0xd0
[ 5520.863251]  [<ffffffff8139106e>] mutex_lock+0x1e/0x40
[ 5520.863264]  [<ffffffffa03390a8>] autofs4_root_ioctl+0x38/0x70 [autofs4]
[ 5520.863274]  [<ffffffff8112d4e7>] do_vfs_ioctl+0x97/0x530
[ 5520.863283]  [<ffffffff8104af2c>] ? sys_wait4+0xac/0xf0
[ 5520.863291]  [<ffffffff8112d9ca>] sys_ioctl+0x4a/0x80
[ 5520.863302]  [<ffffffff81002feb>] system_call_fastpath+0x16/0x1b

Got about 8+ of those in my dmesg right now. Another machine running .36 right 
now, is playing music off the same share, and this machine doesn't lock up at 
all when running .36 as well. Tried 2.6.37-rc1 and now -rc3.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
