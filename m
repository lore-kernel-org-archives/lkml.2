Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2JVPbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:31:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4744 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2JVPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:31:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 22 Oct 2012 08:31:07 -0700
From: Denis Kirjanov <kirjanov@gmail.com>
To: linux-edac@vger.kernel.org
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Denis Kirjanov <kirjanov@gmail.com>
Subject: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Date: Mon, 22 Oct 2012 19:30:58 +0400
Message-ID: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix buffer overrun if no suitable bandwidth found

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 drivers/edac/amd64_edac.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5a297a2..d85ad9e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -188,6 +188,9 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 		 * scrubrates array.
 		 */
 	}
+	if (i == ARRAY_SIZE(scrubrates)) {
+		i--;
+	}
 
 	scrubval = scrubrates[i].scrubval;
 
-- 
1.7.9.5

