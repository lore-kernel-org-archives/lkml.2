Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0D3RGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:06:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab0D3RF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:05:57 -0400
Date: Thu, 29 Apr 2010 23:24:43 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267005265-27958-2-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-2-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86: Fix LOCK_PREFIX_HERE for uniprocessor build
Message-ID: <tip-b701a47ba48b698976fb2fe05fb285b0edc1d26a@git.kernel.org>
Git-Commit-ID: b701a47ba48b698976fb2fe05fb285b0edc1d26a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 23:24:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b701a47ba48b698976fb2fe05fb285b0edc1d26a
Gitweb:     http://git.kernel.org/tip/b701a47ba48b698976fb2fe05fb285b0edc1d26a
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 29 Apr 2010 16:03:57 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 29 Apr 2010 16:08:54 -0700

x86: Fix LOCK_PREFIX_HERE for uniprocessor build

Checkin b3ac891b67bd4b1fc728d1c784cad1212dea433d:
x86: Add support for lock prefix in alternatives

... did not define LOCK_PREFIX_HERE in the case of a uniprocessor
build.  As a result, it would cause any of the usages of this macro to
fail on a uniprocessor build.  Fix this by defining LOCK_PREFIX_HERE
as a null string.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267005265-27958-2-git-send-email-luca@luca-barbieri.com>
---
 arch/x86/include/asm/alternative.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 55fee12..e29a6c9 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -38,6 +38,7 @@
 #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
 
 #else /* ! CONFIG_SMP */
+#define LOCK_PREFIX_HERE ""
 #define LOCK_PREFIX ""
 #endif
 
