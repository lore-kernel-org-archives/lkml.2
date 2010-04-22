Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0DVP7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:59:51 -0400
Received: from bar.sig21.net ([80.81.252.164]:41799 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0DVP7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:59:50 -0400
Date: Thu, 22 Apr 2010 17:59:44 +0200
From: Johannes Stezenbach <js@sig21.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: fat: excessive log spamming due to corrupted fs
Message-ID: <20100422155944.GA22181@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.3 (--)
X-Spam-21-Report: No, score=-2.3 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.521,BAYES_50=0.001 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my office mate has a 1GB USB stick with a currupted vfat fs.

(I don't really know when and how it got currupted.  I
just mounted it, copied a file onto it, unmounted, unplugged.
After that corruption showed up when accessing the newly
copied file.  I'm running 2.6.33.1.)

Mounting still worked but when accessing the new file the kernel
log was filled up with

Apr 22 16:30:18 zzz kernel: FAT: Filesystem error (dev sdb1)
Apr 22 16:30:18 zzz kernel:    fat_get_cluster: invalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel:    File system has been set read-only
Apr 22 16:30:18 zzz kernel: FAT: Filesystem error (dev sdb1)
Apr 22 16:30:18 zzz kernel:    fat_get_cluster: invalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel: FAT: Filesystem error (dev sdb1)
Apr 22 16:30:18 zzz kernel:    fat_get_cluster: invalid cluster chain (i_pos 34568)
...
Apr 22 16:30:18 zzz kernel: FAT: Filesystem error lidAT: Filesysalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fiesysalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fesystalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel: FAT: Filesystem alid cluster chain (i_pos 3AT: Fiesyalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos AT: Fiesystalid cluster chain (i_pos 34568)
Apr 22 16:30:18 zzz kernel: FAT: Filesystealid cluster chain (i_pos 3AT: Fiesystalid cluster chain (i_pos 34568)
...
(~10000 lines)


It seems that fat_fs_error() generates corrupted output
(on an Athlon 4850e dual core), and the excessive amounts
of output are IMHO not useful.


BTW: dosfsck refused to fix it.
BTW2: when my office mate plugged it into her MacBook it
caused MacOS to crash ;-)


Johannes
