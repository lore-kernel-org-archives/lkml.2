Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0ELATN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:19:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab0ELATH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:19:07 -0400
Date: Wed, 12 May 2010 00:18:44 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1273135546-29690-2-git-send-email-avi@redhat.com>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Use the proper asm constraint in use_xsave()
Message-ID: <tip-dce8bf4e115aa44d590802ce3554e926840c9042@git.kernel.org>
Git-Commit-ID: dce8bf4e115aa44d590802ce3554e926840c9042
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 00:18:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dce8bf4e115aa44d590802ce3554e926840c9042
Gitweb:     http://git.kernel.org/tip/dce8bf4e115aa44d590802ce3554e926840c9042
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 10 May 2010 13:41:41 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 10 May 2010 13:41:41 -0700

x86, fpu: Use the proper asm constraint in use_xsave()

The proper constraint for a receiving 8-bit variable is "=qm", not
"=g" which equals "=rim"; even though the "i" will never match, bugs
can and do happen due to the difference between "q" and "r".

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1273135546-29690-2-git-send-email-avi@redhat.com>
---
 arch/x86/include/asm/i387.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 1a8cca3..8002e9c 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -64,7 +64,7 @@ static inline bool use_xsave(void)
 	alternative_io("mov $0, %0",
 		       "mov $1, %0",
 		       X86_FEATURE_XSAVE,
-		       "=g"(has_xsave));
+		       "=qm" (has_xsave));
 
 	return has_xsave;
 }
