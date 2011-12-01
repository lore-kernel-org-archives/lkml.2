Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1LAKlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:41:15 -0500
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:41791 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262Ab1LAKlO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:41:14 -0500
X-Greylist: delayed 2015 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 05:41:14 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] SCSI: aacraid: potential integer overflow in aac_get_containers()
Date: Thu, 1 Dec 2011 02:07:33 -0800
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D061FCB70@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] SCSI: aacraid: potential integer overflow in aac_get_containers()
Thread-Index: Acyv0UxWws6v+ENIRGeaeUf5zEzdEQAP5/ag
References: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
To: "Haogang Chen" <haogangchen@gmail.com>, <aacraid@adaptec.com>
Cc: <JBottomley@parallels.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Dec 2011 10:07:37.0618 (UTC) FILETIME=[0D9C4720:01CCB011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Achim Leubner <Achim_Leubner@pmc-sierra.com>


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Haogang Chen
Sent: Donnerstag, 1. Dezember 2011 03:30
To: aacraid@adaptec.com
Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; haogangchen@gmail.com
Subject: [PATCH] SCSI: aacraid: potential integer overflow in
aac_get_containers()

There is a potential integer overflow in aac_get_containers(). When
maximum_num_containers is large, the subsequent call to kzalloc() will
allocate a buffer smaller than expected, which leads to memory
corruption in the for loop.

The patch replaces kzalloc with kcalloc.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 drivers/scsi/aacraid/aachba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c
index 409f580..440b84d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -381,7 +381,7 @@ int aac_get_containers(struct aac_dev *dev)
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) *
maximum_num_containers,
+	fsa_dev_ptr = kcalloc(maximum_num_containers,
sizeof(*fsa_dev_ptr), 
 			GFP_KERNEL);
 	if (!fsa_dev_ptr)
 		return -ENOMEM;
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
