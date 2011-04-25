Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1DYFvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 01:51:33 -0400
Received: from trent.utfs.org ([194.246.123.103]:35077 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1DYFvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 01:51:20 -0400
Date: Sun, 24 Apr 2011 22:51:17 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110424234655.GC12436@dastard>
Message-ID: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> I'd say they are not being reclaimmmed because the VFS hasn't let go
> of them yet. Can you also dump /proc/sys/fs/{dentry,inode}-state so
> we can see if the VFS has released the inodes such that they can be
> reclaimed by XFS?

Will do that.

> BTW, what are your mount options? If it is the problem I suspect it
> is, then using noatime with stop it from occurring....

# grep xfs /proc/mounts 
/dev/mapper/wdc1 /mnt/backup xfs rw,nosuid,nodev,noexec,relatime,attr2,delaylog,noquota 0 0
/dev/mapper/wdc1 /data xfs ro,relatime,attr2,delaylog,noquota 0 0

The "/dev/mapper/wdc1" is a dm-crypt device on a ~1TB external disk 
(via FireWire). The 2nd line in the output above is a bind-mount from 
somewhere below "/mnt/backup".

I'm currently trying to reproduce the problem again and see if the 
{dentry,inode}-state output reveals any more information. After that, I'll 
try with noatime.

Thanks,
Christian.
-- 
BOFH excuse #115:

your keyboard's space bar is generating spurious keycodes.
