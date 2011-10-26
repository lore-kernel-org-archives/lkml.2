Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1JZVWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:22:50 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35974 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1JZVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:22:49 -0400
Subject: [PATCH] cciss: fix flush cache transfer length
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Wed, 26 Oct 2011 16:22:45 -0500
Message-ID: <20111026212245.15723.30415.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We weren't filling in the transfer length of the
flush cache command (it transfers 4 bytes of zeroes).
Firmware didn't seem to be bothered by this, but it
should be fixed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..54d76ea 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2582,6 +2582,8 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = BMIC_WRITE;
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
+			c->Request.CDB[7] = (size >> 8) & 0xFF;
+			c->Request.CDB[8] = size & 0xFF;
 			break;
 		case TEST_UNIT_READY:
 			c->Request.CDBLen = 6;

