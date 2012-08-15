Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2HOPrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:47:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63107 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2HOPrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:46 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz,
        Robin Dong <hao.bigrat@gmail.com>, Robin Dong <sanbai@taobao.com>
Subject: [PATCH 09/13] overlayfs: fix possible leak in ovl_new_inode
Date: Wed, 15 Aug 2012 17:48:16 +0200
Message-Id: <1345045700-9062-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <hao.bigrat@gmail.com>

After allocating a new inode, if the mode of inode is incorrect, we should
release it by iput().

Signed-off-by: Robin Dong <sanbai@taobao.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 787761f..e854720 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -371,6 +371,7 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 
 	default:
 		WARN(1, "illegal file type: %i\n", mode);
+		iput(inode);
 		inode = NULL;
 	}
 
-- 
1.7.7

