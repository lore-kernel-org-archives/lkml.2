Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0CXFST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:18:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab0CXFSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:18:18 -0400
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 24 Mar 2010 16:12:23 +1100
Subject: [PATCH 0/2] Two patches for fs/super.c
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Message-ID: <20100324051140.10015.32854.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two patches.

 The second removes S_BIAS which is unnecessary and so potentially
 confusing.

 The first I found the need for while preparing the second patch.  It
 seems that get_active_super doesn't follow the pattern of all other
 code that walks the super_blocks list.

NeilBrown

---

NeilBrown (2):
      VFS: use __put_super_and_need_restart in get_active_super.
      fs/super: remove S_BIAS


 fs/notify/inotify/inotify.c |   33 ++++++++++++++-------------------
 fs/super.c                  |   20 ++++++++------------
 include/linux/fs.h          |    1 -
 3 files changed, 22 insertions(+), 32 deletions(-)

-- 

