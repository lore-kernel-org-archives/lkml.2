Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2H0I7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:59:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2H0I7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:59:48 -0400
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 10:59:48 +0200
Message-ID: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com>
Subject: Storage related regression in linux-next 20120824
From: Arvydas Sidorenko <asido4@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next 20120824 introduced regression on Mac mini 2011 - /root partition
gets mounted as read-only and it stays so even when trying to reboot into
previously working kernel. In order to make it work on older kernel again
`fsck` needs to be executed:
----------------------------------------------------------------------
#fsck
e2fsck 1.42.5 (29-Jul-2012)
/dev/sda4 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Directory inode 1572866, block #0, offset 0: directory corrupted
Salvage <y>? yes
Missing '.' in directory inode 1572866.
Fix <y>? yes
Setting filetype for dentry '.' in ??? (1572866) to 2.
Missing '..' in directory inode 1572866.
Fix <y>? yes
Setting filetype for entry '..' in ??? (1572866) to 2.
Directory inode 1595924, block #0, offset 0: directory corrupted
Salvage <y>? yes
Missing '.' in directory inode 1595924.
Fix <y>? yes
Setting filetype for dentry '.' in ??? (1595924) to 2.
Missing '..' in directory inode 1595924.
Fix <y>? yes
Setting filetype for entry '..' in ??? (1595924) to 2.
Pass 3: Checking directory connectivity
'..' in /tmp/.ICE-unix (1572866) is <The NULL inode> (0), should be
/tmp (1572866)
Fix <y>? yes
'..' in /tmp/.X11-unix (1595924) is <The NULL inode> (0), should be
/tmp (1572866)
Fix <y>? yes
Pass 4: Checking reference counts
Inode 2 ref count is 19, should be 21. Fix <y>? yes
Inode 1572866 ref count is 6, should be 4. Fix <y>? yes
Pass 5: Checking group summary information

/dev/sda4 ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda4 ***** REBOOT LINUX *****
/dev/sda4 558313/2392064 files (0.1% non-contiguous), 5882159/9563904 blocks
----------------------------------------------------------------------

Root partition uses ext4 filesystem on Intel 330 SSD connected to SATA3.
dmesg shows that journaling was disabled:
----------------------------------------------------------------------
Aborting journal on device sda4-8
EXT4-fs error (device sda4): ext4_journal_start_sb:348: Detected aborted journal
EXT4-fs (sda4): Remounting filesystem read-only
----------------------------------------------------------------------

I haven't bisected to which exactly tree introduces the regression,
but I can tell
that linux-next 20120813 and v3.6-rc3 work fine.
