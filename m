Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1HSQs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:48:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57410 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095Ab1HSQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:39 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>
Subject: [PATCH v2 42/43] dlm: Remove another superfluous call to recalc_sigpending()
Date: Fri, 19 Aug 2011 17:46:58 +0100
Message-Id: <1313772419-21951-43-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

recalc_sigpending() is called within sigprocmask(), so there is no
need call it again after sigprocmask() has returned. Furthermore, the
call to recalc_sigpending() could race with signal_wake_up() because
it isn't called with sighand->siglock held. I must have missed this
call when removing the other recalc_sigpending() in commit
4bcad6c1ef53 ("dlm: Remove superfluous call to recalc_sigpending())".

Cc: Christine Caulfield <ccaulfie@redhat.com>
Acked-by: David Teigland <teigland@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/dlm/user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index d8ea607..b38b122 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -678,7 +678,6 @@ static int device_close(struct inode *inode, struct file *file)
 	   device_remove_lockspace() */
 
 	sigprocmask(SIG_SETMASK, &tmpsig, NULL);
-	recalc_sigpending();
 
 	return 0;
 }
-- 
1.7.4.4

