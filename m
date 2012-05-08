Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab2EHEGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:06:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2EHEGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:06:37 -0400
Date: Mon, 7 May 2012 21:06:14 -0700
From: tip-bot for Betty Dall <betty.dall@hp.com>
Message-ID: <tip-6ff968cca1dfebd4b6fcade87c11658dbfc96932@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, betty.dall@hp.com, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, betty.dall@hp.com, dzickus@redhat.com
In-Reply-To: <1335559255-13454-1-git-send-email-betty.dall@hp.com>
References: <1335559255-13454-1-git-send-email-betty.dall@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/nmi: Fix the type of the nmiaction.
 flags field
Git-Commit-ID: 6ff968cca1dfebd4b6fcade87c11658dbfc96932
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:06:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ff968cca1dfebd4b6fcade87c11658dbfc96932
Gitweb:     http://git.kernel.org/tip/6ff968cca1dfebd4b6fcade87c11658dbfc96932
Author:     Betty Dall <betty.dall@hp.com>
AuthorDate: Fri, 27 Apr 2012 14:40:55 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 12:32:11 +0200

x86/nmi: Fix the type of the nmiaction.flags field

This patch changes the type of the struct nmiaction flags field
to unsigned long from unsigned int. All the usages of the flags
field are unsigned long already. There is only one flag used
currently, NMI_FLAG_FIRST, but having the wrong size could cause
a truncation bug in the future on 64 bit architectures.

Signed-off-by: Betty Dall <betty.dall@hp.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1335559255-13454-1-git-send-email-betty.dall@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/nmi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index a1a836c..0e3793b 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -40,7 +40,7 @@ typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
-	unsigned int		flags;
+	unsigned long		flags;
 	const char		*name;
 };
 
