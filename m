Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1JNNC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:02:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52579 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1JNNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:02:27 -0400
X-Nat-Received: from [202.181.97.72]:53347 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1318597342.24913
To: pebolle@tiscali.nl, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp
Subject: Re: [PATCH 10/21] tomoyo: drop unused Kconfig symbols
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1318595342.6132.67.camel@x61.thuisdomein>
In-Reply-To: <1318595342.6132.67.camel@x61.thuisdomein>
Message-Id: <201110142202.CHH39010.OHJLFFtQOSMVOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 14 Oct 2011 22:02:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 14102011 #5484850, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
>  security/tomoyo/Kconfig |   24 ------------------------
>  1 files changed, 0 insertions(+), 24 deletions(-)

Thank you for finding. Below patch (for 3.2) fixes this error.
I'll carry below patch on TOMOYO's website (for 3.1).
--------------------
[PATCH] TOMOYO: Fix unused kernel config option.

CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY and
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG introduced by commit 0e4ae0e0
"TOMOYO: Make several options configurable." were by error not used.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 902650b..48bb7af 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -502,8 +502,10 @@ static struct tomoyo_profile *tomoyo_assign_profile
 			TOMOYO_CONFIG_WANT_REJECT_LOG;
 		memset(ptr->config, TOMOYO_CONFIG_USE_DEFAULT,
 		       sizeof(ptr->config));
-		ptr->pref[TOMOYO_PREF_MAX_AUDIT_LOG] = 1024;
-		ptr->pref[TOMOYO_PREF_MAX_LEARNING_ENTRY] = 2048;
+		ptr->pref[TOMOYO_PREF_MAX_AUDIT_LOG] =
+			CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG;
+		ptr->pref[TOMOYO_PREF_MAX_LEARNING_ENTRY] =
+			CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY;
 		mb(); /* Avoid out-of-order execution. */
 		ns->profile_ptr[profile] = ptr;
 		entry = NULL;
