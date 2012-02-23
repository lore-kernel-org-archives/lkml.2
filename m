Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2BWEuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 23:50:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54054 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2BWEuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 23:50:10 -0500
Date: Wed, 22 Feb 2012 20:49:37 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-862ae3132dc393ab6ea750b9ee9e0e1c276b9abb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <4F42E171.9080005@mit.edu>
References: <4F42E171.9080005@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Drop non-__vdso weak symbols from the x32 VDSO
Git-Commit-ID: 862ae3132dc393ab6ea750b9ee9e0e1c276b9abb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 20:50:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  862ae3132dc393ab6ea750b9ee9e0e1c276b9abb
Gitweb:     http://git.kernel.org/tip/862ae3132dc393ab6ea750b9ee9e0e1c276b9abb
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 22 Feb 2012 20:37:10 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 22 Feb 2012 20:40:07 -0800

x32: Drop non-__vdso weak symbols from the x32 VDSO

Drop the legacy weak symbols that don't carry the __vdso prefix from
the x32 VDSO.  This is a new ABI and we don't need to support that
legacy; the actual libc will export the proper symbols.

Suggested-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/4F42E171.9080005@mit.edu
Cc: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/vdso/vdsox32.lds.S |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/vdsox32.lds.S b/arch/x86/vdso/vdsox32.lds.S
index 373ca9a..62272aa 100644
--- a/arch/x86/vdso/vdsox32.lds.S
+++ b/arch/x86/vdso/vdsox32.lds.S
@@ -17,13 +17,9 @@
 VERSION {
 	LINUX_2.6 {
 	global:
-		clock_gettime;
 		__vdso_clock_gettime;
-		gettimeofday;
 		__vdso_gettimeofday;
-		getcpu;
 		__vdso_getcpu;
-		time;
 		__vdso_time;
 	local: *;
 	};
