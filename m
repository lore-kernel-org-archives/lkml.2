Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab1FPOHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:07:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:52154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1FPOHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:07:37 -0400
Date: Thu, 16 Jun 2011 14:07:31 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-406a733db0052fed66d17008430b6047ecea7b92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20110421023739.243651696@goodmis.org>
References: <20110421023739.243651696@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86: Do not trace .discard.text section
Git-Commit-ID: 406a733db0052fed66d17008430b6047ecea7b92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 14:07:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  406a733db0052fed66d17008430b6047ecea7b92
Gitweb:     http://git.kernel.org/tip/406a733db0052fed66d17008430b6047ecea7b92
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 13 Apr 2011 16:43:29 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 17 May 2011 10:41:55 -0400

ftrace/x86: Do not trace .discard.text section

The section called .discard.text has tracing attached to it and is
currently ignored by ftrace. But it does include a call to the mcount
stub. Adding a notrace to the code keeps gcc from adding the useless
mcount caller to it.

Link: http://lkml.kernel.org/r/20110421023739.243651696@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/setup.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index db8aa19..647d8a0 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -88,7 +88,7 @@ void *extend_brk(size_t size, size_t align);
  * executable.)
  */
 #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard.text) __used			\
+	static void __section(.discard.text) __used notrace		\
 	__brk_reservation_fn_##name##__(void) {				\
 		asm volatile (						\
 			".pushsection .brk_reservation,\"aw\",@nobits;" \
