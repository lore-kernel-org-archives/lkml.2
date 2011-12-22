Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1LVRTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:19:31 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:54173 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752810Ab1LVRTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:19:30 -0500
Date: Thu, 22 Dec 2011 17:18:33 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] SCSI: Change size of factor from u64 to unsigned int.
Message-ID: <20111222171833.GA16435@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struct scsi_device.sector_size is unsigned int, so the value of factor
can have at most 23 significant bits.

Adding a type check to do_div() caught these two do_div as the only
invocations in the kernel passing a non-32-bit divisor.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..42a1ff6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1335,8 +1335,7 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 		start_lba <<= 1;
 		end_lba <<= 1;
 	} else {
-		/* be careful ... don't want any overflows */
-		u64 factor = scmd->device->sector_size / 512;
+		unsigned int factor = scmd->device->sector_size / 512;
 		do_div(start_lba, factor);
 		do_div(end_lba, factor);
 	}
