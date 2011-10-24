Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1JXWKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1JXWKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:10:30 -0400
Date: Mon, 24 Oct 2011 18:10:26 -0400
From: Dave Jones <davej@redhat.com>
To: anil_ravindranath@pmc-sierra.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: pmcraid_chr_ioctl uses incorrect argument order to kmalloc()
Message-ID: <20111024221025.GA22337@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	anil_ravindranath@pmc-sierra.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size is 1st arg, not second.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d079f9a..da19bdf 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
 	struct pmcraid_ioctl_header *hdr = NULL;
 	int retval = -ENOTTY;
 
-	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
+	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 
 	if (!hdr) {
 		pmcraid_err("faile to allocate memory for ioctl header\n");
