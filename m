Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1AGQzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:55:46 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:39841 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1AGQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:55:44 -0500
Subject: [PATCH 1/3] hpsa: fix use of uninitialized variable in
	hpsa_add_msa2xxx_enclosure_device()
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com,
        akpm@linux-foundation.org, smcameron@yahoo.com
Date: Fri, 07 Jan 2011 10:55:43 -0600
Message-ID: <20110107165543.14259.80663.stgit@beardog.cce.hp.com>
In-Reply-To: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
References: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix use of uninitialized variable in hpsa_add_msa2xxx_enclosure_device()

Thanks to Scott Teel for noticing this.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c255f46..c6c13b0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1617,6 +1617,8 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (lun == 0) /* if lun is 0, then obviously we have a lun 0. */
 		return 0;
 
+	memset(scsi3addr, 0, 8);
+	scsi3addr[3] = target;
 	if (is_hba_lunid(scsi3addr))
 		return 0; /* Don't add the RAID controller here. */
 
@@ -1631,8 +1633,6 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 		return 0;
 	}
 
-	memset(scsi3addr, 0, 8);
-	scsi3addr[3] = target;
 	if (hpsa_update_device_info(h, scsi3addr, this_device))
 		return 0;
 	(*nmsa2xxx_enclosures)++;

