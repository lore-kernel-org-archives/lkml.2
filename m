Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab1E0Ith (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:49:37 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:55267 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456Ab1E0Itg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:49:36 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: stub_main.c: simplify busid_table initialization
Date: Fri, 27 May 2011 01:49:24 -0700
Message-Id: <8b7b3dd5fe3719c032f351fd2388b2f3feed142a.1306486060.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the whole structure to zero instead of individually setting each
member, which simplifies the for loop.

This was suggested by walter harms <wharms@bfs.de>.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_main.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 45a0f5d..a34249a 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -39,13 +39,9 @@ static void init_busid_table(void)
 {
 	int i;
 
-	for (i = 0; i < MAX_BUSID; i++) {
-		memset(busid_table[i].name, 0, BUSID_SIZE);
+	memset(busid_table, 0, sizeof(busid_table));
+	for (i = 0; i < MAX_BUSID; i++)
 		busid_table[i].status = STUB_BUSID_OTHER;
-		busid_table[i].interf_count = 0;
-		busid_table[i].sdev = NULL;
-		busid_table[i].shutdown_busid = 0;
-	}
 
 	spin_lock_init(&busid_table_lock);
 }
-- 
1.7.5.1

