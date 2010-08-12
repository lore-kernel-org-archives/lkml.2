Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab0HLIae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 04:30:34 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:54283 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab0HLIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 04:30:31 -0400
Date: Thu, 12 Aug 2010 10:31:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH] partitions: fix build error in ibm partition detection code
Message-ID: <20100812083104.GC7814@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] partitions: fix build error in ibm partition detection code

From: Heiko Carstens <heiko.carstens@de.ibm.com>

9c867fbe "partitions: fix sometimes unreadable partition strings" coverted
one line within the ibm partition code incorrectly. Fix this to get rid of
a build error.

fs/partitions/ibm.c: In function 'ibm_partition':
[...]
fs/partitions/ibm.c:185: error: too many arguments to function 'strlcat'

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/partitions/ibm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index d1b8a5c..55610aa 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -182,7 +182,8 @@ int ibm_partition(struct parsed_partitions *state)
 				offset = (info->label_block + 1);
 			} else {
 				/* unlabeled disk */
-				strlcat(tmp, sizeof(tmp), "(nonl)", PAGE_SIZE);
+				snprintf(tmp, sizeof(tmp), "(nonl)");
+				strlcat(state->pp_buf, tmp, PAGE_SIZE);
 				size = i_size >> 9;
 				offset = (info->label_block + 1);
 			}
