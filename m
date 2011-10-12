Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1JLMbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:31:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33904 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1JLM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/13] drbd: cosmetic: fix accidental division instead of modulo when pretty printing
Date: Wed, 12 Oct 2011 14:27:25 +0200
Message-Id: <1318422455-17539-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

For large resync rates, seq_printf_with_thousands_grouping()
accidentally only produced Y,000,00Y, instead of the real numbers.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 6b226cc..7e68d99 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -52,7 +52,7 @@ void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
 	if (unlikely(v >= 1000000)) {
 		/* cool: > GiByte/s */
 		seq_printf(seq, "%ld,", v / 1000000);
-		v /= 1000000;
+		v %= 1000000;
 		seq_printf(seq, "%03ld,%03ld", v/1000, v % 1000);
 	} else if (likely(v >= 1000))
 		seq_printf(seq, "%ld,%03ld", v/1000, v % 1000);
-- 
1.7.4.1

