Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1LNTUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:20:45 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:47679 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1LNTUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:20:43 -0500
Date: Wed, 14 Dec 2011 14:20:40 -0500
Message-Id: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bugfixes for 3.2-rc5
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is a signed tag tytso-for-linus-20111214 covering these patches,
which fix a potential hang, crash (on big endian), and data corruption
bugs which show up when using fsx and/or Hugh's kernel compile/mm
torture test.

Please pull,

						- Ted

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

Paul Mackerras (1):
      ext4: Fix crash due to getting bogus eh_depth value on big-endian systems

Theodore Ts'o (2):
      ext4: fix ext4_end_io_dio() racing against fsync()
      ext4: display the correct mount option in /proc/mounts for [no]init_itable

Yongqiang Yang (4):
      ext4: avoid potential hang in mpage_submit_io() when blocksize < pagesize
      ext4: correctly handle pages w/o buffers in ext4_discard_partial_buffers()
      ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
      ext4: handle EOF correctly in ext4_bio_write_page()

 fs/ext4/extents.c |    3 +-
 fs/ext4/inode.c   |   54 +++++++++-------------------------------------------
 fs/ext4/page-io.c |   12 +++++++++++
 fs/ext4/super.c   |   17 +++++++--------
 4 files changed, 31 insertions(+), 55 deletions(-)


