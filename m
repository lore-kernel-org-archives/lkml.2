Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2ELMCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 08:02:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51175 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2ELMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 08:02:45 -0400
Date: Sat, 12 May 2012 05:02:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] tmpfs: enable NOSEC optimization
In-Reply-To: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1205120500040.28861@eggly.anvils>
References: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let tmpfs into the NOSEC optimization (avoiding file_remove_suid()
overhead on most common writes): set MS_NOSEC on its superblocks.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- 3045N.orig/mm/shmem.c	2012-05-05 10:45:17.888060878 -0700
+++ 3045N/mm/shmem.c	2012-05-05 10:46:05.732062006 -0700
@@ -2361,6 +2361,7 @@ int shmem_fill_super(struct super_block
 		}
 	}
 	sb->s_export_op = &shmem_export_ops;
+	sb->s_flags |= MS_NOSEC;
 #else
 	sb->s_flags |= MS_NOUSER;
 #endif
