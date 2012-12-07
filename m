Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2LGPHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:07:54 -0500
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:39222 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2LGPHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:07:52 -0500
Message-Id: <50C21406020000A10000DCE2@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 07 Dec 2012 16:06:30 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: ext3 corruption in 3.0 kernel (SLES11 SP2 x86_64 (AMD
 Opteron))
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I thought I'd let you know of two ext3 corruptions found on an ADM Opteron server running SLES11 SP2 (kernel-xen-3.0.42-0.7.3). Corruptions occurred at different times in different files on different machines: Too much to be ignored.

The older one looked like this:
[75548.267404] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry in directory #205978: rec_len % 4 != 0 - offset=4096, inode=2531699, rec_len=41331, name_len=38

And a more recent one looks like this:
kernel: [261958.359401] EXT3-fs error (device dm-0): ext3_add_entry: bad entry in directory #85582: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0

As the nodes are running Xen VMM in a cluster, it's possible that node see Resets at any time (fencing), but I thought a journaling filesystem would either not allow or fix corruption.

In both cases I found this problem when a file could not be created like this RPM error message:
Error: RPM failed: error: unpacking of archive failed on file /lib/modules/3.0.42-0.7-default/kernel/drivers/media/video/cpia2/cpia2.ko;50c1fafd: cpio: open failed - Input/output error

After a reset I had to repair the filesystem manually with these type of errors:
Inode 248552 was part of the orphaned inode list.  FIXED.
Block bitmap differences:
Free blocks count wrong for group

After repair and reboot I still saw:
kernel: [  698.061916] EXT3-fs error (device dm-0): ext3_lookup: deleted inode referenced: 68710
kernel: [  698.061916] EXT3-fs error (device dm-0): ext3_lookup: deleted inode referenced: 68711

(dm-0 is the root Logical Volume)

CPU-Details (Sun X4100 Server) are:
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 285
stepping        : 2

(I know this CPU has some bugs with virtualization; is filesystem corruption one of them?)

Regards,
Ulrich


