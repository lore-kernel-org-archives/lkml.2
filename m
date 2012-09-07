Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2IGRkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:40:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27339 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2IGRke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:40:34 -0400
Subject: [PATCH 0/6] fuse: allocate req->pages[] dynamically
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 07 Sep 2012 21:40:37 +0400
Message-ID: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, any fuse request always includes inline pages[] array of
FUSE_MAX_PAGES_PER_REQ elements. This is the waste of memory because
in many cases smaller size would suffice.

The patch-set tries to allocate only as many elements of pages[] array as
actaully needed. This will be even more useful in the future because of:

1. Mitsuo's patches making maximum read/write request size tunable.
2. My patches optimizing scatter-gather direct IO. To make them simplier I'll
need to substitute array of 'struct page *' with array of 'struct bio_vec'.
It would make memory overhead worse if implemented w/o this patch-set.

Thanks,
Maxim

---

Maxim Patlasov (6):
      fuse: general infrastructure for pages[] of variable size
      fuse: categorize fuse_get_req()
      fuse: rework fuse_retrieve()
      fuse: rework fuse_readpages()
      fuse: rework fuse_perform_write()
      fuse: rework fuse_do_ioctl()


 fs/fuse/cuse.c   |    2 +-
 fs/fuse/dev.c    |   70 +++++++++++++++++++++++++++++++++++++-----------------
 fs/fuse/dir.c    |   38 +++++++++++++++--------------
 fs/fuse/file.c   |   53 +++++++++++++++++++++++++----------------
 fs/fuse/fuse_i.h |   45 ++++++++++++++++++++++++++++++-----
 fs/fuse/inode.c  |    6 ++---
 6 files changed, 143 insertions(+), 71 deletions(-)

-- 
Signature
