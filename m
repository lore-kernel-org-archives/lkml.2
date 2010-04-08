Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab0DHQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:58:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57452 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab0DHQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:58:49 -0400
Date: Thu, 8 Apr 2010 12:58:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fix
Message-ID: <20100408165848.GA14360@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 include/linux/ata.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Mark Lord (1):
      libata: Fix accesses at LBA28 boundary (old bug, but nasty) (v2)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index b4c85e2..700c5b9 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1025,8 +1025,8 @@ static inline int ata_ok(u8 status)
 
 static inline int lba_28_ok(u64 block, u32 n_block)
 {
-	/* check the ending block number */
-	return ((block + n_block) < ((u64)1 << 28)) && (n_block <= 256);
+	/* check the ending block number: must be LESS THAN 0x0fffffff */
+	return ((block + n_block) < ((1 << 28) - 1)) && (n_block <= 256);
 }
 
 static inline int lba_48_ok(u64 block, u32 n_block)
