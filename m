Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2DTPGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:06:40 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:4368 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2DTPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:06:36 -0400
Subject: [PATCH 04/17] hpsa: suppress excessively chatty error messages
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:06:34 -0500
Message-ID: <20120420150634.10596.30524.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Default behavior for any CHECK CONDITION excepting a few special cases is to
print out certain parts of the sense buffer and the CDB.  Default behavior
should be to print nothing and let the upper layers or applications decide what
to do about these.  The same information is already available by setting the
appropriate bits of the scsi_logging_level kernel parameter or via
/proc/sys/dev/scsi/logging_level.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 906672b..fcb9fb2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1193,7 +1193,7 @@ static void complete_scsi_command(struct CommandList *cp)
 				break;
 			}
 			/* Must be some other type of check condition */
-			dev_warn(&h->pdev->dev, "cp %p has check condition: "
+			dev_dbg(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 					"Returning result: 0x%x, "

