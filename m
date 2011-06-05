Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1FEKfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 06:35:18 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64075 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab1FEKfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 06:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C8fNXoe1Zw8bd1ne/WCAkmERRlSaoK6SuLY2PGatb1ddGz+9jDbzmAI3w0h95IX5IV
         DdNIfdcEJ83CgJhCRnMrPuuaMiuiCXEi739MgRsCGxVH4ejlNmNMjRV1qJYX17sQHMKb
         Zh1amX/2TgKIasiSnw3KoJwhAqcQEOJ0ovnXE=
From: Connor Hansen <cmdkhh@gmail.com>
To: pjones@redhat.com
Cc: konrad@kernel.org, linux-kernel@vger.kernel.org,
        Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH] iscsi_ibft_find unused variable i
Date: Sun,  5 Jun 2011 03:35:09 -0700
Message-Id: <1307270109-28635-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

int i is only needed if CONFIG_ACPI is set
so move it within ifdef so kernels without ACPI
dont allocate space for nothing. Fixes warning too.

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 drivers/firmware/iscsi_ibft_find.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index f032e44..c2bfa50 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -108,10 +108,10 @@ done:
  */
 unsigned long __init find_ibft_region(unsigned long *sizep)
 {
-	int i;
 	ibft_addr = NULL;
 
 #ifdef CONFIG_ACPI
+	int i;
 	for (i = 0; i < ARRAY_SIZE(ibft_signs) && !ibft_addr; i++)
 		acpi_table_parse(ibft_signs[i].sign, acpi_find_ibft);
 #endif /* CONFIG_ACPI */
-- 
1.7.4.4

