Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2BCPsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:48:42 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:35171 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2BCPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:48:29 -0500
From: Corey Minyard <cminyard@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/6] ipmi: Increase KCS timeouts
Date: Fri, 03 Feb 2012 09:47:55 -0600
Message-id: <1328284079-5489-2-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

We currently time out and retry KCS transactions after 1 second of waiting
for IBF or OBF. This appears to be too short for some hardware. The IPMI
spec says "All system software wait loops should include error timeouts. For
simplicity, such timeouts are not shown explicitly in the flow diagrams. A
five-second timeout or greater is recommended". Change the timeout to five
seconds to satisfy the slow hardware.

From: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
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
1.7.4.1

