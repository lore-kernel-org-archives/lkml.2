Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1HAVpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:45:12 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15011 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1HAVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:45:07 -0400
Date: Mon, 1 Aug 2011 23:45:06 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-scsi@vger.kernel.org,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH][Resend] SCSI: pmcraid: Fix swapped kmalloc() arguments
Message-ID: <alpine.LNX.2.00.1108012343230.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pmcraid_chr_ioctl() contains a kmalloc() call where the arguments are
switched, fix that.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/pmcraid.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b86db84..559440b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4102,8 +4102,7 @@ static long pmcraid_chr_ioctl(
 	struct pmcraid_ioctl_header *hdr = NULL;
 	int retval = -ENOTTY;
 
-	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
-
+	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 	if (!hdr) {
 		pmcraid_err("faile to allocate memory for ioctl header\n");
 		return -ENOMEM;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

