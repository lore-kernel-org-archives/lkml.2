Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1JZVVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:21:21 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35538 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1JZVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:21:18 -0400
Subject: [PATCH 5/5] hpsa: fix flush cache transfer length
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mikem@beardog.cce.hp.com
Date: Wed, 26 Oct 2011 16:21:17 -0500
Message-ID: <20111026212117.15570.3563.stgit@beardog.cce.hp.com>
In-Reply-To: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 646516f..45477b0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2876,6 +2876,8 @@ static void fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = BMIC_WRITE;
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
+			c->Request.CDB[7] = (size >> 8) & 0xFF;
+			c->Request.CDB[8] = size & 0xFF;
 			break;
 		case TEST_UNIT_READY:
 			c->Request.CDBLen = 6;

