Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0JVJ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:56:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab0JVJ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:56:20 -0400
Date: Fri, 22 Oct 2010 09:55:51 GMT
From: tip-bot for Alexander van Heukelum <heukelum@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, heukelum@fastmail.fm, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1287696649.20421.1401306095@webmail.messagingengine.com>
References: <1287696649.20421.1401306095@webmail.messagingengine.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, asm: Fix ancient-GAS workaround
Message-ID: <tip-a22dcdb0032c78c6b443f6897d7ac432a3b5a272@git.kernel.org>
Git-Commit-ID: a22dcdb0032c78c6b443f6897d7ac432a3b5a272
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 09:55:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a22dcdb0032c78c6b443f6897d7ac432a3b5a272
Gitweb:     http://git.kernel.org/tip/a22dcdb0032c78c6b443f6897d7ac432a3b5a272
Author:     Alexander van Heukelum <heukelum@fastmail.fm>
AuthorDate: Thu, 21 Oct 2010 23:30:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 10:45:02 +0200

x86, asm: Fix ancient-GAS workaround

It turns out to generate something like this:

    printk ( ("<3>") "something");

The extra parentheses here break the UML compile.

Change the sed-program to add the parentheses only for numbers.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <1287696649.20421.1401306095@webmail.messagingengine.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Kbuild |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Kbuild b/Kbuild
index 3995939..431f7ca 100644
--- a/Kbuild
+++ b/Kbuild
@@ -53,7 +53,8 @@ targets += arch/$(SRCARCH)/kernel/asm-offsets.s
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
 	"/^->/{s:->#\(.*\):/* \1 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 (\2) /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 (\2) /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
 	s:->::; p;}"
 endef
 
