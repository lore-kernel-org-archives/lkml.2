Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab2F0JFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:05:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33877 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0JFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:05:01 -0400
Date: Wed, 27 Jun 2012 12:04:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 3/3 -resend] [SCSI] pmcraid: find_first_zero_bit() takes bits
 not bytes
Message-ID: <20120627090452.GL31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The find_first_zero_bit() function takes the size in bits not bytes.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This patch was originally sent on Wed, 2 May 2012.

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a38dade..719619a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5376,7 +5376,7 @@ static unsigned short pmcraid_get_minor(void)
 {
 	int minor;
 
-	minor = find_first_zero_bit(pmcraid_minor, sizeof(pmcraid_minor));
+	minor = find_first_zero_bit(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
 	__set_bit(minor, pmcraid_minor);
 	return minor;
 }
