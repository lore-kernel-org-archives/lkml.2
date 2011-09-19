Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1ISX5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:57:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27908 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1ISX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:57:18 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Date: Mon, 19 Sep 2011 19:57:08 -0400
Message-Id: <1316476217-sup-4802@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E77D6DD.0046:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs tree on github:

Head commit: a66e7cc626f42de6c745963fe0d807518fa49d39
git://github.com/chrismason/linux.git for-linus

Has the following fixes.  for-linus is against rc6, since some of these
are regression fixes for earlier 3.1 btrfs commits.  The most important
of the bunch is Josef's dentry fix, which avoids enoents if we race with
multiple procs hitting on the same inode.  This bug is btrfs-specific,
it came in with his optimization to cache the inode location during
readdir.

Li Zefan (3) commits (+9/-5):
    Btrfs: don't make a file partly checksummed through file clone (+5/-0)
    Btrfs: don't change inode flag of the dest clone file (+0/-1)
    Btrfs: fix pages truncation in btrfs_ioctl_clone() (+4/-4)

Josef Bacik (1) commits (+11/-2):
    Btrfs: only clear the need lookup flag after the dentry is setup

Jeff Liu (1) commits (+7/-2):
    BTRFS: Fix lseek return value for error

Hidetoshi Seto (1) commits (+3/-2):
    btrfs: fix d_off in the first dirent

Total: (6) commits (+30/-11)

 fs/btrfs/file.c  |    9 +++++++--
 fs/btrfs/inode.c |   18 ++++++++++++++----
 fs/btrfs/ioctl.c |   14 +++++++++-----
 3 files changed, 30 insertions(+), 11 deletions(-)
