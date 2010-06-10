Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0FJMZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:25:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:47531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0FJMZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:25:21 -0400
Date: Thu, 10 Jun 2010 12:24:49 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, ak@linux.intel.com, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, ak@linux.intel.com, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C10C930.9080900@kernel.org>
References: <4C10C930.9080900@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] percpu, x86: Avoid warnings of unused variables in per cpu
Message-ID: <tip-157a9df3b0f8042f1a6a4fe9e0e494431aaca1ae@git.kernel.org>
Git-Commit-ID: 157a9df3b0f8042f1a6a4fe9e0e494431aaca1ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 12:24:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  157a9df3b0f8042f1a6a4fe9e0e494431aaca1ae
Gitweb:     http://git.kernel.org/tip/157a9df3b0f8042f1a6a4fe9e0e494431aaca1ae
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Thu, 10 Jun 2010 13:10:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Jun 2010 14:09:30 +0200

percpu, x86: Avoid warnings of unused variables in per cpu

Avoid hundreds of warnings with a gcc 4.6 -Wall build.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4C10C930.9080900@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0797e74..cd28f9a 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -77,6 +77,7 @@ do {							\
 	if (0) {					\
 		pto_T__ pto_tmp__;			\
 		pto_tmp__ = (val);			\
+		(void)pto_tmp__;			\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
@@ -115,6 +116,7 @@ do {									\
 	if (0) {							\
 		pao_T__ pao_tmp__;					\
 		pao_tmp__ = (val);					\
+		(void)pao_tmp__;					\
 	}								\
 	switch (sizeof(var)) {						\
 	case 1:								\
