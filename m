Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2AEKiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 05:38:06 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:34661
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2AEKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 05:38:04 -0500
Date: Thu, 5 Jan 2012 11:37:59 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <217150909.20120105113759@eikelenboom.it>
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm having some troubles with a ext4 filesystem on LVM, it seems bricked and fsck doesn't seem to find and correct the problem.

Steps:
1) fsck -v -p -f the filesystem
2) mount the filesystem
3) Try to copy a file
4) filesystem will be mounted RO on error  (see below)
5) fsck again, journal will be recovered, no other errors
6) start at 1)


I think the way i bricked it is:
- make a lvm snapshot from that lvm logical disk
- mount that lvm snapshot as RO
- try to copy a file from that mounted RO snapshot to a diffrent dir on the lvm logical disk the snapshot is from.
- it fails and i can't recover (see above)


Is there a way to recover from this ?



[  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
[  220.749415] Aborting journal on device dm-2-8.
[  220.771633] EXT4-fs error (device dm-2): ext4_journal_start_sb:327: Detected aborted journal
[  220.772593] EXT4-fs (dm-2): Remounting filesystem read-only
[  220.792455] EXT4-fs (dm-2): Remounting filesystem read-only
[  220.805118] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 9680 pages, ino 4079617; err -30
serveerstertje:/mnt/xen_images/domains/production# cd /
serveerstertje:/# umount /mnt/xen_images/
serveerstertje:/# fsck -f -v -p /dev/serveerstertje/xen_images
fsck from util-linux-ng 2.17.2
/dev/mapper/serveerstertje-xen_images: recovering journal

     277 inodes used (0.00%)
       5 non-contiguous files (1.8%)
       0 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 41/41/3
         Extent depth histogram: 69/28/2
51890920 blocks used (79.18%)
       0 bad blocks
      41 large files

     199 regular files
      53 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
      16 symbolic links (16 fast symbolic links)
       0 sockets
--------
     268 files
serveerstertje:/#




System:
- Kernel 3.2.0
- Debian Squeeze with:
ii  e2fslibs                              1.41.12-4stable1                     ext2/ext3/ext4 file system libraries
ii  e2fsprogs                             1.41.12-4stable1                     ext2/ext3/ext4 file system utilities

