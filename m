Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0IPWPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab0IPWPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:23 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 31/34] union-mount: Follow mount in __lookup_union()
Date: Thu, 16 Sep 2010 15:12:22 -0700
Message-Id: <1284675145-4391-32-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for read-only layers of a union to have submounts, we have to
follow mounts on directories in union lookup.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0041334..cdff001 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -811,6 +811,8 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			goto out_found_file;
 		}
 
+		follow_mount(&lower);
+
 		/*
 		 * Now we know the target is a directory.  Create a
 		 * matching topmost directory if one doesn't already
-- 
1.6.3.3

