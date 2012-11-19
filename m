Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2KSFbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51125 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2KSFbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:32 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 38/58] block: Mark internal function blk_drain_queue static
Date: Sun, 18 Nov 2012 21:28:17 -0800
Message-Id: <1353302917-13995-39-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of block/blk-core.c references blk_drain_queue, so mark
it static.  This eliminates warnings from GCC (-Wmissing-prototypes) and
Sparse (-Wdecl).

block/blk-core.c:360:6: warning: no previous prototype for ‘blk_drain_queue’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f338553..c96a6e5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -357,7 +357,7 @@ EXPORT_SYMBOL(blk_put_queue);
  * If not, only ELVPRIV requests are drained.  The caller is responsible
  * for ensuring that no new requests which need to be drained are queued.
  */
-void blk_drain_queue(struct request_queue *q, bool drain_all)
+static void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
 	int i;
 
-- 
1.7.10.4

