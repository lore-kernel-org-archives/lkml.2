Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1EWP55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab1EWP5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:57:25 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dlm: Remove superfluous call to recalc_sigpending()
Date: Mon, 23 May 2011 10:57:17 -0500
Message-Id: <1306166240-3359-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

recalc_sigpending() is called within sigprocmask(), so there is no
need call it again after sigprocmask() has returned.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index d5ab3fe..e96bf3e 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -611,7 +611,6 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 
  out_sig:
 	sigprocmask(SIG_SETMASK, &tmpsig, NULL);
-	recalc_sigpending();
  out_free:
 	kfree(kbuf);
 	return error;
-- 
1.7.1.1

