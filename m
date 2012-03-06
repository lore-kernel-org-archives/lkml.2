Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab2CFM4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:56:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44238 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2CFM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:56:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.14.33.204 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 0/9] vfs: path lookup fixes and cleanups
Date: Tue,  6 Mar 2012 13:56:32 +0100
Message-Id: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a prerequisite for the atomic-open patches I will post shortly.
It contains fixes and cleanups that stand on their own.

Please apply.

Thanks,
Miklos

---
Miklos Szeredi (9):
      vfs: fix double put after complete_walk()
      vfs: fix return value from do_last()
      vfs: fix d_need_lookup/d_revalidate order in do_lookup
      vfs: don't revalidate just looked up dentry
      vfs: move MAY_EXEC check from __lookup_hash()
      vfs: set LOOKUP_JUMPED in follow_managed
      vfs: reorganize do_lookup
      vfs: split __lookup_hash
      nfs: don't open in ->d_revalidate

---
 fs/namei.c    |  228 ++++++++++++++++++++++++---------------------------------
 fs/nfs/dir.c  |   47 +-----------
 fs/nfs/file.c |   69 ++++++++++++++++-
 3 files changed, 167 insertions(+), 177 deletions(-)


