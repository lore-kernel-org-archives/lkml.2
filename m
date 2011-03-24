Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1CXN46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:56:58 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51591 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab1CXN45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:56:57 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt.fleming@linux.intel.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH] dlm: Remove superfluous call to recalc_sigpending()
Date: Thu, 24 Mar 2011 13:56:47 +0000
Message-Id: <1300975007-1944-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

recalc_sigpending() is called within sigprocmask(), so there is no
need call it again after sigprocmask() has returned.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 fs/dlm/user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 66d6c16..d9da93c 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -632,7 +632,6 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 
  out_sig:
 	sigprocmask(SIG_SETMASK, &tmpsig, NULL);
-	recalc_sigpending();
  out_free:
 	kfree(kbuf);
 	return error;
-- 
1.7.4

