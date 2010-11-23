Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0KWNkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:40:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0KWNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:40:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vm5tyh4gy/NRSpmatBL009Y47JdnmuLecyFuO7vuIYj+DIlCDwO23x32fRVQ6VQFhl
         cOULzger3G1A2HMNiuQbrTfF9GPmUpQINcx18wL6KqQKXpSUeYGzCv0U15GXqgNL7ylV
         Holsj54lahjVjixS1uqedRwUkSloPGnKknpUU=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH v3 17/22] ufs: use little-endian bitops
Date: Tue, 23 Nov 2010 22:38:19 +0900
Message-Id: <1290519504-3958-18-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
No change from previous submission
 fs/ufs/util.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 9f8775c..64f7559 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -408,7 +408,7 @@ static inline unsigned _ubh_find_next_zero_bit_(
 	for (;;) {
 		count = min_t(unsigned int, size + offset, uspi->s_bpf);
 		size -= count - offset;
-		pos = ext2_find_next_zero_bit (ubh->bh[base]->b_data, count, offset);
+		pos = find_next_zero_le_bit((unsigned long *)ubh->bh[base]->b_data, count, offset);
 		if (pos < count || !size)
 			break;
 		base++;
-- 
1.7.3.2

