Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2FIOE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 10:04:27 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:38916 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab2FIOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 10:04:17 -0400
From: Josh Hunt <johunt@akamai.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Hunt <johunt@akamai.com>
Subject: [PATCH 2/2] scsi: properly initialize atomic_t scsi_host_next_hn
Date: Sat,  9 Jun 2012 07:03:39 -0700
Message-Id: <1339250619-1561-2-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339250619-1561-1-git-send-email-johunt@akamai.com>
References: <1339250619-1561-1-git-send-email-johunt@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize atomic_t scsi_host_next_hn as per the guidelines defined in Documentation/atomic_ops.txt

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/scsi/hosts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index a3a056a..2b6a03d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -42,7 +42,7 @@
 #include "scsi_logging.h"
 
 
-static atomic_t scsi_host_next_hn;	/* host_no for next new host */
+static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
 
 
 static void scsi_host_cls_release(struct device *dev)
-- 
1.7.0.4

