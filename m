Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2EBKeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:34:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51229 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2EBKeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:34:08 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: "Juergen E . Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, trivial@kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] scsi: aha152x: Fix sparse warning and make printing pointer address more portable.
Date: Wed,  2 May 2012 11:34:01 +0100
Message-Id: <1335954841-18899-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to change use of "0x%08x" in favour of "%p" as per ../Documentation/printk-formats.txt,
which also takes care about the following warning during compilation time:

  drivers/scsi/aha152x.c: In function ‘get_command’:
  drivers/scsi/aha152x.c:2987: warning: cast from pointer to integer of different size

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/scsi/aha152x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 19a3694..dd4547b 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2984,8 +2984,8 @@ static int get_command(char *pos, Scsi_Cmnd * ptr)
 	char *start = pos;
 	int i;
 
-	SPRINTF("0x%08x: target=%d; lun=%d; cmnd=( ",
-		(unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	SPRINTF("%p: target=%d; lun=%d; cmnd=( ",
+		ptr, ptr->device->id, ptr->device->lun);
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
-- 
1.7.2.5

