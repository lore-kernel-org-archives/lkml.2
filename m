Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2ISAKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:10:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2ISAKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:10:30 -0400
Date: Tue, 18 Sep 2012 17:10:19 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-a8615af4bc3621cb01096541dafa6f68352ec2d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        viro@zeniv.linux.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        hpa@linux.intel.com
In-Reply-To: <1347300665-6209-6-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-6-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: remove cpu_has_xmm check in the fx_finit()
Git-Commit-ID: a8615af4bc3621cb01096541dafa6f68352ec2d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 18 Sep 2012 17:10:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8615af4bc3621cb01096541dafa6f68352ec2d9
Gitweb:     http://git.kernel.org/tip/a8615af4bc3621cb01096541dafa6f68352ec2d9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 10 Sep 2012 10:40:08 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Sep 2012 15:52:24 -0700

x86, fpu: remove cpu_has_xmm check in the fx_finit()

CPUs with FXSAVE but no XMM/MXCSR (Pentium II from Intel,
Crusoe/TM-3xxx/5xxx from Transmeta, and presumably some of the K6
generation from AMD) ever looked at the mxcsr field during
fxrstor/fxsave. So remove the cpu_has_xmm check in the fx_finit()

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1347300665-6209-6-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 0ca72f0..92f3c6e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -109,8 +109,7 @@ static inline void fx_finit(struct i387_fxsave_struct *fx)
 {
 	memset(fx, 0, xstate_size);
 	fx->cwd = 0x37f;
-	if (cpu_has_xmm)
-		fx->mxcsr = MXCSR_DEFAULT;
+	fx->mxcsr = MXCSR_DEFAULT;
 }
 
 extern void __sanitize_i387_state(struct task_struct *);
