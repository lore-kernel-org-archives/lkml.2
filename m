Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2JIUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:14:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2JIUON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/8] SCSI: ARM: make fas216_dumpinfo function conditional
Date: Tue,  9 Oct 2012 22:13:52 +0200
Message-Id: <1349813638-4617-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kAL3QSaspt1z9qO9j/JVQc8FEjH9Ijp2H4JzF1DjMEj
 FzIv/Jy+RrxnVUfG4fuoZ9uU7CUh1ljed29OasilMezT3fOs8u
 d5BIk8hQ1kdmaztXDCzDh9h1UmZwn6JP2fwGmPBl2DgrO6Ynhg
 5Ri8qrzDSASrgGecreLhrqaVfqQ8+OV4kC0r3D1eX8A6c0iilo
 QKts1BZ4K2/HvqFHV5YIE2lPrkCv6g8u0cKsvpxV1oMnmg6xZq
 gZPdp6akF5rxmlF9s9t4Vljf9v49Iz04CkukbglR2MQSR3T5ef
 boGqK2DPqKlIwLxB0hdZm8h/ZU96PZdipREj5dOmutnmA3ZeMN
 ry40yyd4N1nElvTHv8OljIDkpEGIbleqw4an2neAy
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

