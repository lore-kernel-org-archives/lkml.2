Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2EBGM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:12:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27830 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2EBGM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:12:28 -0400
Date: Wed, 2 May 2012 09:12:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] pmcraid: find_first_zero_bit() takes bits not bytes
Message-ID: <20120502061222.GA1111@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The find_first_zero_bit() function takes the size in bits not bytes.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ea8a0b4..b0f6f0b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5379,7 +5379,7 @@ static unsigned short pmcraid_get_minor(void)
 {
 	int minor;
 
-	minor = find_first_zero_bit(pmcraid_minor, sizeof(pmcraid_minor));
+	minor = find_first_zero_bit(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
 	__set_bit(minor, pmcraid_minor);
 	return minor;
 }
