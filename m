Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1GZAWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:22:13 -0400
Received: from mail001.aei.ca ([206.123.6.130]:59075 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1GZAWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:22:08 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: Linux 3.0 release - btrfs possible locking deadlock
Date: Mon, 25 Jul 2011 20:22:03 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-crc+; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@redhat.com>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com> <201107221921.00798.edt@aei.ca> <1311623259-sup-8037@shiny>
In-Reply-To: <1311623259-sup-8037@shiny>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107252022.03834.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 July 2011 15:49:37 Chris Mason wrote:
> Excerpts from Ed Tomlinson's message of 2011-07-22 19:21:00 -0400:
> > On Thursday 21 July 2011 22:59:53 Linus Torvalds wrote:
> > > So there it is. Gone are the 2.6.<bignum> days, and 3.0 is out.
> > > 
> > 
> > Hi,
> > 
> > Managed to get this with btrfs rsync(ing) from ext4 to a btrfs fs with three partitions using raid1.
> > 
> > [16018.211493] device fsid f7186eeb-60df-4b1a-890a-4a1eb42f81fe devid 1 transid 10 /dev/sdd4
> > [16018.230643] btrfs: use lzo compression
> > [16018.234619] btrfs: enabling disk space caching
> > [25949.414011] 
> > [25949.414011] =======================================================
> > [25949.416549] [ INFO: possible circular locking dependency detected ]
> > [25949.423187] 3.0.0-crc+ #348
> > [25949.423187] -------------------------------------------------------
> > [25949.423187] rsync/20237 is trying to acquire lock:
> > [25949.423187]  (btrfs-extent-01){+.+...}, at: [<ffffffffa047ce88>] btrfs_try_spin_lock+0x78/0xb0 [btrfs]
> > [25949.423187] 
> > [25949.423187] but task is already holding lock:
> > [25949.423187]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa047cee2>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
> > [25949.423187] 
> > [25949.423187] which lock already depends on the new lock.
> > 
> > Kernel is 3.0.0 without any extras.
> > 
> > Ideas?
> 
> Did this actually deadlock?  lockdep has issues with the btrfs
> clear_lock_blocking code, and I need to redo the annotations a bit.  The
> problem is that we have the same lock class representing unrelated locks from
> different trees.

It did not stop any processes that I could see and the rsync did complete ok.  Thats why I said possible.
Figured it might be something you needed to see and/or fix though.

Thanks
Ed
