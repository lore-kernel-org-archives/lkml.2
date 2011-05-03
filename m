Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1ECT6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:58:52 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:34852 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1ECT6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:58:50 -0400
Subject: [PATCH 01/16] hpsa: do readl after writel in main i/o path to ensure
	commands don't get lost.
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:58:49 -0500
Message-ID: <20110503195849.5478.13229.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Apparently we've been doin it rong for a decade, but only lately do we
run into problems.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 621a153..98c97ca 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -212,6 +212,7 @@ static void SA5_submit_command(struct ctlr_info *h,
 	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
 		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	h->commands_outstanding++;
 	if (h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;

