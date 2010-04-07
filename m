Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0DGMst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:21270 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab0DGMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:21 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJN-01-9UF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/12] dma-debug: Cleanup for copy-loop in filter_write()
Date: Wed, 7 Apr 2010 14:46:48 +0200
Message-ID: <1270644409-10123-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0101 (UTC) FILETIME=[67D1C950:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

Earlier in this function we set the last byte of "buf" to NULL so we
always hit the break statement and "i" is never equal to NAME_MAX_LEN.
This patch doesn't change how the driver works but it silences a Smatch
warning and it makes it clearer that we don't write past the end of the
array.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ba8b670..01e6427 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 * Now parse out the first token and use it as the name for the
 	 * driver to filter for.
 	 */
-	for (i = 0; i < NAME_MAX_LEN; ++i) {
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
 		current_driver_name[i] = buf[i];
 		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
 			break;
-- 
1.7.0.4


