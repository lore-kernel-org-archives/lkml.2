Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1K1QOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:14:52 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38001 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1K1QOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:14:50 -0500
Subject: [PATCH 2/2] cciss: fix flush cache transfer length
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Mon, 28 Nov 2011 10:14:48 -0600
Message-ID: <20111128161448.25472.60872.stgit@beardog.cce.hp.com>
In-Reply-To: <20111128161442.25472.71410.stgit@beardog.cce.hp.com>
References: <20111128161442.25472.71410.stgit@beardog.cce.hp.com>
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
index 6f22ed0..587cce5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2601,6 +2601,8 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = BMIC_WRITE;
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
+			c->Request.CDB[7] = (size >> 8) & 0xFF;
+			c->Request.CDB[8] = size & 0xFF;
 			break;
 		case TEST_UNIT_READY:
 			c->Request.CDBLen = 6;

