Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1LIAdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:33:43 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38186 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab1LIAdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:33:41 -0500
Date: Thu, 8 Dec 2011 16:30:42 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] tomoyo: add missing rcu_dereference()
Message-ID: <20111209003042.GA17905@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a missed rcu_dereference() around real_parent.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/tomoyo/common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index ed311d7..cb9f5c2 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -1122,7 +1122,7 @@ static inline pid_t tomoyo_sys_getppid(void)
 {
 	pid_t pid;
 	rcu_read_lock();
-	pid = task_tgid_vnr(current->real_parent);
+	pid = task_tgid_vnr(rcu_dereference(current->real_parent));
 	rcu_read_unlock();
 	return pid;
 }
-- 
1.7.0.4

