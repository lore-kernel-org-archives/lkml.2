Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1DZO1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:27:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32973 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab1DZO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:27:00 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Btrfs" <linux-btrfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Date: Tue, 26 Apr 2011 10:24:22 -0400
Message-Id: <1303824244-sup-5010@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DB6D613.0115:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The master branch of the btrfs unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a few bug fixes.  Josef fixed up a crash in the free space cache
error handling code, and it should close out the open bugs there.

Li Zefan found a slab corruption in btrfs fitrim support.

Otherwise, these are smaller fixes for corner cases.

This is a separate pull from my plugging fixes because this is against
2.6.38, while the plugging stuff was on top of 2.6.39-rc4.

David Sterba (1) commits (+1/-0):
    btrfs: add missing spin_unlock to a rare exit path

Itaru Kitayama (1) commits (+1/-1):
    btrfs: fix wrong allocating flag when reading page

Josef Bacik (2) commits (+8/-5):
    Btrfs: free bitmaps properly when evicting the cache (+7/-4)
    Btrfs: put the right bio if we have an error (+1/-1)

Li Zefan (1) commits (+1/-1):
    Btrfs: Free free_space item properly in btrfs_trim_block_group()

Tsutomu Itoh (3) commits (+21/-8):
    Btrfs: fix missing mutex_unlock in btrfs_del_dir_entries_in_log() (+5/-2)
    Btrfs: cleanup error handling in inode.c (+9/-6)
    Btrfs: check return value of kmalloc() (+7/-0)

Total: (8) commits (+32/-15)

 fs/btrfs/disk-io.c          |    1 +
 fs/btrfs/extent-tree.c      |    4 ++++
 fs/btrfs/extent_io.c        |    2 +-
 fs/btrfs/free-space-cache.c |   13 ++++++++-----
 fs/btrfs/inode.c            |   20 +++++++++++++-------
 fs/btrfs/tree-log.c         |    7 +++++--
 6 files changed, 32 insertions(+), 15 deletions(-)
