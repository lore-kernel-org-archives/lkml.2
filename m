Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935544Ab0HFKvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:51:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33586 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934475Ab0HFKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:51:39 -0400
To: torvalds@linux-foundation.org
CC: htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: [git pull] fuse: add store and retrieve support
Message-Id: <E1OhKWV-0005hN-Cl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Aug 2010 12:51:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This series enables userspace filesystems to store and retrieve data
in the kernel page cache.  This allows filesystems to

 - poll for changes on mmap regions
 - update contents of mmaped or cached regions
 - pre-fill cache

This interface is also necessary to support mmap on character devices
(CUSE), which in turn is necessary for full OSS emulation (Tejun's
OSSProxy project).  Mmap support is not yet finished but coming
shortly.

Thanks,
Miklos

----
Miklos Szeredi (3):
      fuse: don't use atomic kmap
      fuse: add store request
      fuse: add retrieve request

---
 fs/fuse/dev.c        |  229 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/file.c       |    2 +-
 fs/fuse/fuse_i.h     |    3 +
 include/linux/fuse.h |   34 +++++++-
 4 files changed, 260 insertions(+), 8 deletions(-)
