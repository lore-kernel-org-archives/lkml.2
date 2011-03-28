Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1C1PSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:18:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39981 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab1C1PSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:18:40 -0400
Date: Mon, 28 Mar 2011 10:02:06 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs updates for 2.6.39-rc1
Message-ID: <20110328150205.GA9054@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The eCryptfs patches for 2.6.39-rc1 are mainly fixes. Roberto's patches
add key locking so keys aren't modified underneath us. Thieu's patch
moves encryption to writepage so userspace isn't waiting on page
encryption during each write(). My patches remove a wasteful
encrypt/write operation during file creation and fix a missing page
unlock in an error path.

The following changes since commit 40471856f2e38e9bfa8d605295e8234421110dd6:

  Merge branch 'nfs-for-2.6.39' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-25 10:03:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Roberto Sassu (6):
      eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
      eCryptfs: removed num_global_auth_toks from ecryptfs_mount_crypt_stat
      eCryptfs: modified size of keysig in the ecryptfs_key_sig structure
      eCryptfs: verify authentication tokens before their use
      eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before mutex_lock
      eCryptfs: write lock requested keys

Thieu Le (1):
      ecryptfs: modify write path to encrypt page in writepage

Tyler Hicks (3):
      eCryptfs: Remove unnecessary grow_file() function
      eCryptfs: Remove ECRYPTFS_NEW_FILE crypt stat flag
      eCryptfs: Unlock page in write_begin error path

 fs/ecryptfs/crypto.c          |    2 +-
 fs/ecryptfs/ecryptfs_kernel.h |   30 ++---
 fs/ecryptfs/file.c            |    9 ++-
 fs/ecryptfs/inode.c           |   24 ----
 fs/ecryptfs/keystore.c        |  272 ++++++++++++++++++++++++++---------------
 fs/ecryptfs/main.c            |   10 +-
 fs/ecryptfs/mmap.c            |   61 +++++----
 fs/ecryptfs/read_write.c      |   12 +--
 fs/ecryptfs/super.c           |    3 +-
 9 files changed, 235 insertions(+), 188 deletions(-)
