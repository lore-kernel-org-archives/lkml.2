Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1LIA2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:28:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54155 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab1LIA2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:28:46 -0500
Date: Thu, 8 Dec 2011 16:25:48 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] apparmor: add missing rcu_dereference()
Message-ID: <20111209002548.GA30520@www.outflux.net>
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
 security/apparmor/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index 96502b2..f3fafed 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -133,7 +133,7 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
 		struct aa_profile *profile = sa->aad.profile;
 		pid_t pid;
 		rcu_read_lock();
-		pid = tsk->real_parent->pid;
+		pid = rcu_dereference(tsk->real_parent)->pid;
 		rcu_read_unlock();
 		audit_log_format(ab, " parent=%d", pid);
 		if (profile->ns != root_ns) {
-- 
1.7.0.4

