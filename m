Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1BBCgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:36:46 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:37389 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1BBCgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:36:45 -0500
Date: Tue, 1 Feb 2011 18:36:44 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, xfs@oss.sgi.com
Subject: XFS stat/statvfs problems with 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110202023644.GA25214@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since updating past 2.6.37, I'm seeing du(1) sometimes report files
taking up 8GB even though ls(1) reports the correct size (hundreds of
bytes).  At the same time, df reports that the filesystem is 95% or 100%
full (although I can still write to the filesystem).  Repeated du calls
show persistent results (once st_blocks is wrong, it stays wrong).
Rebooting clears the problem for a few hours, then it seems to come
back, although the exact files affected seems to change.  xfs_check
doesn't find any errors, and rebooting into 2.6.37 clears up the problem
entirely.

There's nothing in dmesg indicating a problem:

Jan 27 08:04:37 pyron kernel: [    0.000000] Linux version 2.6.38-rc2-00175-g6fb1b30 (adi@pyron) (gcc version 4.4.5 (Debian 4.4.5-10) ) #75 SMP Thu Jan 27 00:39:11 PST 2011
Jan 27 08:04:37 pyron kernel: [    8.420170] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
Jan 27 08:04:37 pyron kernel: [    8.434527] XFS mounting filesystem dm-8
Jan 27 08:04:37 pyron kernel: [    8.676644] Starting XFS recovery on filesystem: dm-8 (logdev: internal)
Jan 27 08:04:37 pyron kernel: [    8.734279] Ending XFS recovery on filesystem: dm-8 (logdev: internal)
Jan 27 08:04:37 pyron kernel: [    8.762724] XFS mounting filesystem dm-9
Jan 27 08:04:37 pyron kernel: [    8.957986] Ending clean XFS mount for filesystem: dm-9
Jan 27 08:04:37 pyron kernel: [    8.985909] XFS mounting filesystem dm-10
Jan 27 08:04:37 pyron kernel: [    9.098404] Starting XFS recovery on filesystem: dm-10 (logdev: internal)
Jan 27 08:04:37 pyron kernel: [    9.205018] Ending XFS recovery on filesystem: dm-10 (logdev: internal)


/d1 is a 200GB XFS on DM on AHCI SATA on a Core i7 desktop board.
The erroneous statvfs reports are visible in this munin graph:
http://web.hexapodia.org/~adi/tmp/20110201-df-pyron.png
(the filesystem is actually 72% full currently, and should be linearly
filling as is visible around Jan 26.)

% sudo xfs_info /d1
meta-data=/dev/mapper/vg0-d1     isize=256    agcount=4, agsize=13107200 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=52428800, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=25600, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I'm back on 2.6.37 right now, I'll try a new git tip tonight.

-andy
