Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3AESN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 13:13:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab3AESN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 13:13:26 -0500
Date: Sat, 5 Jan 2013 19:13:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: CAI Qian <caiqian@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linda Wang <lwang@redhat.com>, Matt Zywusko <mzywusko@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] signals: sys_ssetmask() uses uninitialized newmask
Message-ID: <20130105181313.GB13076@redhat.com>
References: <688203485.8555438.1357377797739.JavaMail.root@redhat.com> <1757046472.8555813.1357378462241.JavaMail.root@redhat.com> <20130105181254.GA13076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105181254.GA13076@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

77097ae5 "most of set_current_blocked() callers want SIGKILL/SIGSTOP
removed from set" removed the initialization of newmask by accident,
restore.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@kernel.org	# v3.5+
---
 kernel/signal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7aaa51d..9692499 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3286,6 +3286,7 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
 	int old = current->blocked.sig[0];
 	sigset_t newset;
 
+	siginitset(&newset, newmask);
 	set_current_blocked(&newset);
 
 	return old;
-- 
1.5.5.1


