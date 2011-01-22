Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1AVNOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:14:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1AVNOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JzwbGT0eIFSpv9pbhUoFAYCWYwmge3uhFfXSHxKli/mhDpJzRE7Ds6rmzttExj6HNR
         UXz9MuKGwnZ6hY1cbjTxdOjGa+1VClnSQLWuUVsjKShUBA8mGPEsaJa6T5zkal2DdA6Q
         b2vrxKmSPjVuOSLfGyhWBLAKN0J0OtmtC5hfk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH v5 22/27] ufs: use little-endian bitops
Date: Sat, 22 Jan 2011 22:13:54 +0900
Message-Id: <1295702039-23186-23-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
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

Change from v4:
 - remove casts to "unsigned long *" due to le-bitops prototype change

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 fs/ufs/util.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 9f8775c..9541759 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -408,7 +408,7 @@ static inline unsigned _ubh_find_next_zero_bit_(
 	for (;;) {
 		count = min_t(unsigned int, size + offset, uspi->s_bpf);
 		size -= count - offset;
-		pos = ext2_find_next_zero_bit (ubh->bh[base]->b_data, count, offset);
+		pos = find_next_zero_bit_le(ubh->bh[base]->b_data, count, offset);
 		if (pos < count || !size)
 			break;
 		base++;
-- 
1.7.3.4

