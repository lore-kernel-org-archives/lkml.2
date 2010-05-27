Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0E0KrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:47:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:32769 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0E0KrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:47:07 -0400
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] fuse: support splice() on fuse device
Message-Id: <E1OHac4-0000AH-ED@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 May 2010 12:46:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

This series adds support for splice() on the fuse device, allowing
userspace filesystem implementations to transfer data to/from the
kernel with reduced number of memory copies.

The only changes outside the fuse tree are addition of EXPORT_SYMBOLs.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos
---

Dan Carpenter (1):
      fuse: remove unneeded variable

Miklos Szeredi (8):
      fuse: use get_user_pages_fast()
      fuse: get page reference for readpages
      fuse: support splice() writing to fuse device
      mm: export lru_cache_add_*() to modules
      mm: export remove_from_page_cache() to modules
      fuse: allow splice to move pages
      fuse: support splice() reading from fuse device
      mm: export generic_pipe_buf_*() to modules

---
 fs/fuse/dev.c        |  527 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/file.c       |   39 +++--
 fs/fuse/fuse_i.h     |    3 +
 fs/pipe.c            |    6 +
 include/linux/fuse.h |    5 +-
 mm/filemap.c         |    1 +
 mm/swap.c            |    1 +
 7 files changed, 500 insertions(+), 82 deletions(-)
