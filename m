Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0CXDWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:22:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0CXDWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:22:43 -0400
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 24 Mar 2010 14:20:08 +1100
Subject: [PATCH 0/3] refcounting improvements in sysfs.
Cc: linux-kernel@vger.kernel.org
Message-ID: <20100324031829.2136.66489.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series tidies up the refcount of sysfs_dirents in sysfs,
using kref where appropriate and a new karef for s_active.
This achieves significant code simplification, especially the first
patch.

This is in part inspired by http://lwn.net/Articles/336224/ :-)

NeilBrown

---

NeilBrown (3):
      sysfs: simplify handling for s_active refcount
      sysfs: make s_count a kref
      kref: create karef and use for sysfs_dirent->s_active


 fs/sysfs/dir.c       |   74 ++++++++++++++++++++------------------------------
 fs/sysfs/mount.c     |    3 +-
 fs/sysfs/sysfs.h     |   19 +++++--------
 include/linux/kref.h |   38 ++++++++++++++++++++++++++
 lib/kref.c           |   13 +++++++++
 5 files changed, 90 insertions(+), 57 deletions(-)

-- 
Signature

