Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2GZQeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:34:21 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34232 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2GZQeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:34:18 -0400
Subject: [PATCH 2/3] hpsa: fix incorrect abort diagnostic message
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Thu, 26 Jul 2012 11:34:17 -0500
Message-ID: <20120726163417.25864.82410.stgit@beardog.cce.hp.com>
In-Reply-To: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
References: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In the abort handler, when asked to abort a command which
is not known to the driver, SUCCESS is returned, but the
diagnostic message incorrectly indicates the abort failed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 015a6c8..415db96 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2609,7 +2609,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	/* not in reqQ, if also not in cmpQ, must have already completed */
 	found = hpsa_find_cmd_in_queue(h, sc, &h->cmpQ);
 	if (!found)  {
-		dev_dbg(&h->pdev->dev, "%s Request FAILED (not known to driver).\n",
+		dev_dbg(&h->pdev->dev, "%s Request SUCCEEDED (not known to driver).\n",
 				msg);
 		return SUCCESS;
 	}

