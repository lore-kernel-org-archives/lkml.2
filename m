Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0FHOaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:30:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46326 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0FHOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:30:08 -0400
To: jens.axboe@oracle.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <E1OLznJ-0003rR-OZ@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 08 Jun 2010 16:28:45 +0200)
Subject: [PATCH 2/2] pipe: remove bogus check from "set size" fcntl
References: <E1OLznJ-0003rR-OZ@pomaz-ex.szeredi.hu>
Message-Id: <E1OLzoX-0003sA-2Y@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jun 2010 16:30:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

As it stands this check compares the number of pages to the page size.
This makes no sense and makes the fcntl fail in almost any sane case.

Fix it by removing the check completely, round_pipe_size() will make
sure that nr_pages >= 1 anyway.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/pipe.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-06-08 14:14:59.000000000 +0200
+++ linux-2.6/fs/pipe.c	2010-06-08 14:22:45.000000000 +0200
@@ -1211,9 +1211,6 @@ long pipe_fcntl(struct file *file, unsig
 		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
 			ret = -EPERM;
 			goto out;
-		} else if (nr_pages < PAGE_SIZE) {
-			ret = -EINVAL;
-			goto out;
 		}
 		ret = pipe_set_size(pipe, nr_pages);
 		break;
