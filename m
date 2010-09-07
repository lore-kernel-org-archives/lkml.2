Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0IGKHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab0IGKHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:07:18 -0400
Subject: dlm: Fix dlm lock status block comment in dlm.h
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 07 Sep 2010 11:13:09 +0100
Message-ID: <1283854389.2495.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is only one place in the dlm where the sb_status is set
and that is queue_cast(). Tracing back the callers of that
function shows that the listed set of return values is
out of date, so here are an updated set.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index 0b3518c..0994309 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -48,10 +48,10 @@ typedef void dlm_lockspace_t;
  *
  * 0 if lock request was successful
  * -EAGAIN if request would block and is flagged DLM_LKF_NOQUEUE
- * -ENOMEM if there is no memory to process request
- * -EINVAL if there are invalid parameters
  * -DLM_EUNLOCK if unlock request was successful
  * -DLM_ECANCEL if a cancel completed successfully
+ * -EDEADLK if a deadlock was detected
+ * -ETIMEDOUT if the lock request was canceled due to a timeout
  */
 
 #define DLM_SBF_DEMOTED		0x01


