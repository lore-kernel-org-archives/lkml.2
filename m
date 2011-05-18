Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab1ERSem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:34:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:44805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933451Ab1ERSek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:34:40 -0400
Date: Wed, 18 May 2011 18:34:32 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-2895cd2ab81dfb7bc22637bc110857db44a30b4a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20110421023739.243651696@goodmis.org>
References: <20110421023739.243651696@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86: Do not trace .discard.text section
Git-Commit-ID: 2895cd2ab81dfb7bc22637bc110857db44a30b4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 18:34:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2895cd2ab81dfb7bc22637bc110857db44a30b4a
Gitweb:     http://git.kernel.org/tip/2895cd2ab81dfb7bc22637bc110857db44a30b4a
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 13 Apr 2011 16:43:29 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 16 May 2011 14:47:13 -0400

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
