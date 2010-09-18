Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0IRTlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:41:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39380 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab0IRTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:41:36 -0400
Date: Sat, 18 Sep 2010 20:41:35 +0100
To: linux-arch@vger.kernel.org
Subject: [PATCH 1/5] frv: restart_block.fn needs to be reset on sigreturn
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ox3Hz-0006R7-As@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/frv/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 0974c0e..7fc2961 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -121,6 +121,9 @@ static int restore_sigcontext(struct sigcontext __user *sc, int *_gr8)
 	struct user_context *user = current->thread.user;
 	unsigned long tbr, psr;
 
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
 	tbr = user->i.tbr;
 	psr = user->i.psr;
 	if (copy_from_user(user, &sc->sc_context, sizeof(sc->sc_context)))
-- 
1.5.6.5


