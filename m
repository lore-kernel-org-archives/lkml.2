Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1HWJQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:16:16 -0400
Received: from mga12.intel.com ([143.182.124.36]:49762 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754538Ab1HWJQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:16:14 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Aug 2011 05:16:13 EDT
Subject: Re: linux-next: build failure after merge of the final tree
 (ptrace tree related)
From: Matt Fleming <matt.fleming@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
In-Reply-To: <20110823160309.112ad0f4922be8605b61c8dd@canb.auug.org.au>
References: <20110823160309.112ad0f4922be8605b61c8dd@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 23 Aug 2011 10:06:26 +0100
Message-ID: <1314090386.3600.2.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 16:03 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> kernel/signal.c: In function 'block_sigmask':
> kernel/signal.c:2333:26: error: 'SA_NODEFER' undeclared (first use in this function)
> 
> Caused by commit 932e5a25b9cf ("signal: Add block_sigmask() for adding
> sigmask to current->blocked").  Sparc seems to use SA_NOMASK in the
> equivalent bit of code and has no SA_NODEFER definition.
> 
> I discovered this after releasing linux-next today.

Ouch, my bad. Thanks for the heads up Stephen!

Guys, how about this patch?

--------8<--------

>From 1358a0ab01b95344cd542e5139bc4865650fbf4e Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Tue, 23 Aug 2011 09:54:58 +0100
Subject: [PATCH] sparc: Make SA_NOMASK a synonym of SA_NODEFER

Unlike other architectures, sparc currently has no SA_NODEFER
definition but only the older SA_NOMASK. Since SA_NOMASK is the
historical name for SA_NODEFER, add SA_NODEFER and copy what other
architectures do by making SA_NOMASK a synonym for SA_NODEFER.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/sparc/include/asm/signal.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/signal.h b/arch/sparc/include/asm/signal.h
index e49b828..aa42fe3 100644
--- a/arch/sparc/include/asm/signal.h
+++ b/arch/sparc/include/asm/signal.h
@@ -143,10 +143,11 @@ struct sigstack {
 #define SA_ONSTACK	_SV_SSTACK
 #define SA_RESTART	_SV_INTR
 #define SA_ONESHOT	_SV_RESET
-#define SA_NOMASK	0x20u
+#define SA_NODEFER	0x20u
 #define SA_NOCLDWAIT    0x100u
 #define SA_SIGINFO      0x200u
 
+#define SA_NOMASK	SA_NODEFER
 
 #define SIG_BLOCK          0x01	/* for blocking signals */
 #define SIG_UNBLOCK        0x02	/* for unblocking signals */
-- 
1.7.4.4



