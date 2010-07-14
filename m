Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0GNAzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:55:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0GNAy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:54:59 -0400
Date: Wed, 14 Jul 2010 00:54:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinhai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinhai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4C3BDDA3.2060900@kernel.org>
References: <4C3BDDA3.2060900@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, alternatives: Fix one more open-coded 8-bit alternative number
Message-ID: <tip-df378ccfc4dd04e263426ad805516915874774aa@git.kernel.org>
Git-Commit-ID: df378ccfc4dd04e263426ad805516915874774aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 00:54:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df378ccfc4dd04e263426ad805516915874774aa
Gitweb:     http://git.kernel.org/tip/df378ccfc4dd04e263426ad805516915874774aa
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 13 Jul 2010 14:55:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Jul 2010 14:56:16 -0700

x86, alternatives: Fix one more open-coded 8-bit alternative number

Fix a missing case of an 8-bit alternative number, buried inside an
assembly macro.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Reported-by: Yinghai Lu <yinhai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <4C3BDDA3.2060900@kernel.org>
---
 arch/x86/lib/copy_user_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 71100c9..a460158 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -29,7 +29,7 @@
 	.align 8
 	.quad  0b
 	.quad  2b
-	.byte  \feature			/* when feature is set */
+	.word  \feature			/* when feature is set */
 	.byte  5
 	.byte  5
 	.previous
