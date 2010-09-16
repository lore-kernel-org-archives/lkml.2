Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0IPWPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0IPWPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:03 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 24/34] union-mount: Prevent bind mounts of union mounts
Date: Thu, 16 Sep 2010 15:12:15 -0700
Message-Id: <1284675145-4391-25-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent bind mounts of parts of union mounts.

XXX - Bind mounting parts of union mounts is probably easy to
implement, but requires some careful thought about corner cases,
extensive testing, and some refactoring of the code.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 26efaf3..e3629dd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1761,6 +1761,12 @@ static int do_loopback(struct path *path, char *old_name,
 	err = -EINVAL;
 	if (IS_MNT_UNBINDABLE(old_path.mnt))
 		goto out;
+	/*
+	 * XXX - Mounting a subtree of a union mount elsewhere
+	 * requires careful thought and some refactoring.
+	 */
+	if (IS_MNT_UNION(old_path.mnt))
+		goto out;
 
 	if (!check_mnt(path->mnt) || !check_mnt(old_path.mnt))
 		goto out;
-- 
1.6.3.3

