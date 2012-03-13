Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab2CMAqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:46:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:48290 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986Ab2CMAXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 128/196] Increase OSF partition limit from 8 to 18
Date: Mon, 12 Mar 2012 20:20:41 -0400
Message-Id: <1331598109-31424-83-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 34d211a2d5df4984a35b18d8ccacbe1d10abb067 upstream.

It turns out that while a maximum of 8 partitions may be what people
"should" have had, you can actually fit up to 18 entries(*) in a sector.

And some people clearly were taking advantage of that, like Michael
Cree, who had ten partitions on one of his OSF disks.

(*) The OSF partition data starts at byte offset 64 in the first sector,
    and the array of 16-byte partition entries start at offset 148 in
    the on-disk partition structure.

Reported-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/partitions/osf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/partitions/osf.c b/fs/partitions/osf.c
index 6e0825e..9ddca58 100644
--- a/fs/partitions/osf.c
+++ b/fs/partitions/osf.c
@@ -10,7 +10,7 @@
 #include "check.h"
 #include "osf.h"
 
-#define MAX_OSF_PARTITIONS 8
+#define MAX_OSF_PARTITIONS 18
 
 int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-- 
1.7.9.3

