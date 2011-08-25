Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1HYIUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:20:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1HYIUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:20:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=wMljQZ+/kMPFNZCTLtkhkD+nFipEvzli0jJiwvY/VeU4AN9Uuv4oVrQHwlJSecAlJ
	u5xF8VnWQJYf+PU5GBuDg==
From: =?UTF-8?q?Ren=C3=A9=20Nussbaumer?= <rn@google.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Ren=C3=A9=20Nussbaumer?= <rn@google.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>, drbd-dev@lists.linbit.com
Subject: [PATCH] DRBD: Fix /proc/drbd output
Date: Thu, 25 Aug 2011 10:20:03 +0200
Message-Id: <1314260403-5572-1-git-send-email-rn@google.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 4b0715f096 introduced an inconsistency in the output of /proc/drbd
while resyncing. Before that patch the "finish:"-line was places on a
new line with one tab indent. This is still true if the unit is KB but
not if it's MB.

This bug is not present in the upstream version of DRBD 8.3.11.

Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
CC: drbd-dev@lists.linbit.com
Signed-off-by: René Nussbaumer <rn@google.com>
---
 drivers/block/drbd/drbd_proc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 2959cdf..7340546 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -97,10 +97,12 @@ static void drbd_syncer_progress(struct drbd_conf *mdev, struct seq_file *seq)
 			    (unsigned long) Bit2KB(rs_left >> 10),
 			    (unsigned long) Bit2KB(mdev->rs_total >> 10));
 	else
-		seq_printf(seq, "(%lu/%lu)K\n\t",
+		seq_printf(seq, "(%lu/%lu)K",
 			    (unsigned long) Bit2KB(rs_left),
 			    (unsigned long) Bit2KB(mdev->rs_total));
 
+	seq_printf(seq, "\n\t");
+
 	/* see drivers/md/md.c
 	 * We do not want to overflow, so the order of operands and
 	 * the * 100 / 100 trick are important. We do a +1 to be
-- 
1.7.3.1

