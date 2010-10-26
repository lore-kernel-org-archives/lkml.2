Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0JZOFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:05:46 -0400
Received: from tomasu.net ([64.85.170.234]:40282 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab0JZOFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:05:45 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org, xen-users@lists.xensource.com
Subject: Strange fsck messages showing up in dmesg
Date: Tue, 26 Oct 2010 08:05:37 -0600
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010260805.37501.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently on an Xen based system I've seen some odd messages show up in dmesg.

Stuff like this:

[3949276.262287] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[3949276.263130] SGI XFS Quota Management subsystem
[3949276.276566] JFS: nTxBlock = 8192, nTxLock = 65536
[3949276.297503] NTFS driver 2.1.29 [Flags: R/W MODULE].
[3949276.333813] QNX4 filesystem 0.2.3 registered.
[3949276.476177] Btrfs loaded
[3949276.867188] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949276.867192] EXT3-fs: write access will be enabled during recovery.
[3949277.084027] kjournald starting.  Commit interval 5 seconds
[3949277.084045] EXT3-fs: dm-5: orphan cleanup on readonly fs
[3949277.084056] ext3_orphan_cleanup: deleting unreferenced inode 442426
[3949277.098238] EXT3-fs: dm-5: 1 orphan inode deleted
[3949277.098242] EXT3-fs: recovery complete.
[3949277.106404] EXT3-fs: mounted filesystem with ordered data mode.
[3949277.451437] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949277.451442] EXT3-fs: write access will be enabled during recovery.
[3949278.572363] kjournald starting.  Commit interval 5 seconds
[3949278.572383] EXT3-fs: dm-11: orphan cleanup on readonly fs
[3949278.607555] ext3_orphan_cleanup: deleting unreferenced inode 116982
[3949278.630313] ext3_orphan_cleanup: deleting unreferenced inode 176017
[3949278.637064] ext3_orphan_cleanup: deleting unreferenced inode 176021
[3949278.642266] ext3_orphan_cleanup: deleting unreferenced inode 176024
[3949278.649033] ext3_orphan_cleanup: deleting unreferenced inode 176019
[3949278.649282] ext3_orphan_cleanup: deleting unreferenced inode 115179
[3949278.659725] EXT3-fs: dm-11: 6 orphan inodes deleted
[3949278.659729] EXT3-fs: recovery complete.
[3949278.688276] EXT3-fs: mounted filesystem with ordered data mode.
[3949278.943069] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949278.943074] EXT3-fs: write access will be enabled during recovery.
[3949279.198661] kjournald starting.  Commit interval 5 seconds
[3949279.198678] EXT3-fs: recovery complete.
[3949279.199994] EXT3-fs: mounted filesystem with ordered data mode.
[3949279.410843] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949279.410848] EXT3-fs: write access will be enabled during recovery.
[3949280.109453] kjournald starting.  Commit interval 5 seconds
[3949280.109473] EXT3-fs: dm-15: orphan cleanup on readonly fs
[3949280.132329] ext3_orphan_cleanup: deleting unreferenced inode 622644
[3949280.150231] ext3_orphan_cleanup: deleting unreferenced inode 172094
[3949280.160631] ext3_orphan_cleanup: deleting unreferenced inode 173498
[3949280.172884] ext3_orphan_cleanup: deleting unreferenced inode 528273
[3949280.173123] ext3_orphan_cleanup: deleting unreferenced inode 528277
[3949280.179544] ext3_orphan_cleanup: deleting unreferenced inode 528280
[3949280.186560] ext3_orphan_cleanup: deleting unreferenced inode 528275
[3949280.186809] EXT3-fs: dm-15: 7 orphan inodes deleted
[3949280.186812] EXT3-fs: recovery complete.
[3949280.218673] EXT3-fs: mounted filesystem with ordered data mode.
[3949280.484659] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949280.484664] EXT3-fs: write access will be enabled during recovery.
[3949281.395053] kjournald starting.  Commit interval 5 seconds
[3949281.395073] EXT3-fs: dm-17: orphan cleanup on readonly fs
[3949281.412858] ext3_orphan_cleanup: deleting unreferenced inode 590002
[3949281.412891] ext3_orphan_cleanup: deleting unreferenced inode 590001
[3949281.421143] ext3_orphan_cleanup: deleting unreferenced inode 590000
[3949281.421167] ext3_orphan_cleanup: deleting unreferenced inode 589999
[3949281.429390] ext3_orphan_cleanup: deleting unreferenced inode 589947
[3949281.429414] EXT3-fs: dm-17: 5 orphan inodes deleted
[3949281.429416] EXT3-fs: recovery complete.
[3949281.440057] EXT3-fs: mounted filesystem with ordered data mode.
[3949281.757369] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949281.757374] EXT3-fs: write access will be enabled during recovery.
[3949283.699865] kjournald starting.  Commit interval 5 seconds
[3949283.699879] EXT3-fs: recovery complete.
[3949283.709767] EXT3-fs: mounted filesystem with ordered data mode.
[3949284.351090] kjournald starting.  Commit interval 5 seconds
[3949284.351104] EXT3-fs: mounted filesystem with ordered data mode.
[3949285.527724] kjournald starting.  Commit interval 5 seconds
[3949285.527739] EXT3-fs: mounted filesystem with ordered data mode.
[3949286.527844] kjournald starting.  Commit interval 5 seconds
[3949286.527862] EXT3-fs: mounted filesystem with ordered data mode.
[3949287.635016] EXT3-fs: INFO: recovery required on readonly filesystem.
[3949287.635022] EXT3-fs: write access will be enabled during recovery.
[3949287.642678] kjournald starting.  Commit interval 5 seconds
[3949287.642690] EXT3-fs: dm-15: orphan cleanup on readonly fs
[3949287.649032] EXT3-fs warning (device dm-15): ext3_orphan_get: bad orphan 
inode 622644!  e2fsck was run?
[3949287.649040] ext3_test_bit(bit=51, block=2490369) = 0
[3949287.649044] inode=(null)
[3949287.649047] EXT3-fs: recovery complete.
[3949287.649309] EXT3-fs: mounted filesystem with ordered data mode.
[3949288.760909] kjournald starting.  Commit interval 5 seconds
[3949288.760922] EXT3-fs: mounted filesystem with ordered data mode.
[3949289.923387] kjournald starting.  Commit interval 5 seconds
[3949289.923399] EXT3-fs: mounted filesystem with ordered data mode.
[3949307.103738] kjournald starting.  Commit interval 5 seconds
[3949307.103746] EXT3-fs: mounted filesystem with ordered data mode.
[3949307.287380] kjournald starting.  Commit interval 5 seconds
[3949307.287393] EXT3-fs: mounted filesystem with ordered data mode.
[3949307.496658] kjournald starting.  Commit interval 5 seconds
[3949307.496670] EXT3-fs: mounted filesystem with ordered data mode.
[3949307.645924] kjournald starting.  Commit interval 5 seconds
[3949307.645936] EXT3-fs: mounted filesystem with ordered data mode.
[3949307.806866] kjournald starting.  Commit interval 5 seconds
[3949307.806880] EXT3-fs: mounted filesystem with ordered data mode.
[3949307.962089] kjournald starting.  Commit interval 5 seconds
[3949307.962102] EXT3-fs: mounted filesystem with ordered data mode.
[3949308.319142] kjournald starting.  Commit interval 5 seconds
[3949308.319157] EXT3-fs: mounted filesystem with ordered data mode.
[3949309.268562] kjournald starting.  Commit interval 5 seconds
[3949309.268575] EXT3-fs: mounted filesystem with ordered data mode.
[3949310.493423] kjournald starting.  Commit interval 5 seconds
[3949310.493439] EXT3-fs: mounted filesystem with ordered data mode.
[3949311.558342] kjournald starting.  Commit interval 5 seconds
[3949311.558357] EXT3-fs: mounted filesystem with ordered data mode.
[3949312.535056] kjournald starting.  Commit interval 5 seconds
[3949312.535069] EXT3-fs: mounted filesystem with ordered data mode.
[3949313.481093] kjournald starting.  Commit interval 5 seconds
[3949313.481106] EXT3-fs: mounted filesystem with ordered data mode.

This Dom0 is a pretty basic debian install. I'm not sure what is attempting to 
automount and fsck all of the volumes on this system, but it is completely 
unexpected.

Anybody know where this is coming from?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
