Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1K3TM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:12:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1K3TMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:12:54 -0500
From: Matthew Garrett <mjg@redhat.com>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] ipmi: Increase KCS timeouts
Date: Wed, 30 Nov 2011 14:12:27 -0500
Message-Id: <1322680347-25743-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently time out and retry KCS transactions after 1 second of waiting
for IBF or OBF. This appears to be too short for some hardware. The IPMI
spec says "All system software wait loops should include error timeouts. For
simplicity, such timeouts are not shown explicitly in the flow diagrams. A
five-second timeout or greater is recommended". Change the timeout to five
seconds to satisfy the slow hardware.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_kcs_sm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index cf82fed..e53fc24 100644
--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -118,8 +118,8 @@ enum kcs_states {
 #define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH
 
 /* Timeouts in microseconds. */
-#define IBF_RETRY_TIMEOUT 1000000
-#define OBF_RETRY_TIMEOUT 1000000
+#define IBF_RETRY_TIMEOUT 5000000
+#define OBF_RETRY_TIMEOUT 5000000
 #define MAX_ERROR_RETRIES 10
 #define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
 
-- 
1.7.7.1

