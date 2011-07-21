Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1GUJTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:19:02 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57228 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1GUJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:46 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Vitaliy Ivanov <vitalivanov@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 03/10] uml: drivers/slip_user.c memory leak fix
Date: Thu, 21 Jul 2011 11:18:27 +0200
Message-Id: <1311239914-8301-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>

Do not free memory when you failed to allocate it.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/slip_user.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index a1c2d2c..cbacfc4 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -102,7 +102,7 @@ static int slip_tramp(char **argv, int fd)
 		       "buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
-		goto out_free;
+		goto out_close;
 	}
 
 	close(fds[1]);
@@ -112,7 +112,6 @@ static int slip_tramp(char **argv, int fd)
 	err = helper_wait(pid);
 	close(fds[0]);
 
-out_free:
 	kfree(output);
 	return err;
 
-- 
1.7.6

