Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2JEO5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:57:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2JEO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/16] SCSI: ARM: make fas216_dumpinfo function conditional
Date: Fri,  5 Oct 2012 16:55:18 +0200
Message-Id: <1349448930-23976-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ohcDqDMidpqe/T7qk0zYUp6CKmfAq4PXr6GLHa0lBf4
 XIGdh5kw8xCNvL2tel10aTPz8akL1Vb7YypfCQwsaZs0LyW4ph
 XCyErDqs06NIlNuxoB/YUTEDu5RkUtPllM8p98WTn0PDRyW6wt
 xNvStUs2k1PyboFDvYrjWlzfpwV+nHxo2M/n/CGTwSLSKW4pyQ
 ZK5mFMh51GX6kwTJiLaTI+ezkET10g+NafLERErhB6dk8t1Tec
 Ch+ny6/3elXO8Mvtb3e4VdMOrA7lc3E2m+Bb9Z5jJJcV4+sOjn
 YgaR+x65whKRtH8JB5nTn0p+8oMRlip/F5XBWbrBQAMNFzsutu
 N2ljuNAB05p0YwTr1UaBClDLI63gFsKpUwHPrCID1w7Yd8Kteo
 Ev0VNILy4VG5DteD1gmxi0SCQyD+JPPOnE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fas216_dumpinfo function is only used by __fas216_checkmagic,
which is conditionally compiled, so we should put both functions
inside of the same #ifdef.

Without this patch, building rpc_defconfig results in:

drivers/scsi/arm/fas216.c:182:13: warning: 'fas216_dumpinfo' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/arm/fas216.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 6206a66..737554c 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -179,6 +179,7 @@ static void print_SCp(struct scsi_pointer *SCp, const char *prefix, const char *
 		SCp->buffers_residual, suffix);
 }
 
+#ifdef CHECK_STRUCTURE
 static void fas216_dumpinfo(FAS216_Info *info)
 {
 	static int used = 0;
@@ -223,7 +224,6 @@ static void fas216_dumpinfo(FAS216_Info *info)
 		info->internal_done, info->magic_end);
 }
 
-#ifdef CHECK_STRUCTURE
 static void __fas216_checkmagic(FAS216_Info *info, const char *func)
 {
 	int corruption = 0;
-- 
1.7.10

