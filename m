Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0KWNV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:21:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab0KWNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:21:27 -0500
Subject: dlm: Fix comment in dlm.h regarding lock_dlm() return values
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 23 Nov 2010 13:21:41 +0000
Message-ID: <1290518501.2423.8.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The code in dlm_lock() explicitly tests for a return value of
-EAGAIN and changes it to zero in that case, so this function
can never return -EAGAIN. I'm not 100% sure that it can
return -ENOTCONN either, but the code paths are more tricky
to trace in that case, so I've left that one for now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index d4e02f5..3b4236c 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -112,7 +112,6 @@ int dlm_release_lockspace(dlm_lockspace_t *lockspace, int force);
  * Returns:
  * 0 if request is successfully queued for processing
  * -EINVAL if any input parameters are invalid
- * -EAGAIN if request would block and is flagged DLM_LKF_NOQUEUE
  * -ENOMEM if there is no memory to process request
  * -ENOTCONN if there is a communication error
  *


