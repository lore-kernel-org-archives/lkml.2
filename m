Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1APNKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:10:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1APNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TChDNLZRnK2ynyh393mO2UQGqrDxo59JPqhkfTd1sH/SaepiBm6Al0lu02c+bvzLKJ
         eg9pglOt/xCFgV5fCLkt3mauKhwe2yL9+RV8uiQ/D672Dm6VW3NQUiFoKCSlCfy264Mn
         0uZIVCoe8joO6CEDViqH9MHPL7BQEmY5oGnI8=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH v4 19/24] ufs: use little-endian bitops
Date: Sun, 16 Jan 2011 22:08:48 +0900
Message-Id: <1295183333-13802-20-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 fs/ufs/util.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 9f8775c..1972168 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -408,7 +408,7 @@ static inline unsigned _ubh_find_next_zero_bit_(
 	for (;;) {
 		count = min_t(unsigned int, size + offset, uspi->s_bpf);
 		size -= count - offset;
-		pos = ext2_find_next_zero_bit (ubh->bh[base]->b_data, count, offset);
+		pos = find_next_zero_bit_le((unsigned long *)ubh->bh[base]->b_data, count, offset);
 		if (pos < count || !size)
 			break;
 		base++;
-- 
1.7.3.4

