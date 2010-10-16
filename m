Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0JPBQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:16:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0JPBQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:16:46 -0400
Date: Fri, 15 Oct 2010 21:16:45 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org,
        linux-m32r@ml.linux-m32r.org, viro@zeniv.linux.org.uk
Subject: [PATCH 1/4] m32r: restore _BLOCKABLE
Message-ID: <20101016011645.GS8332@bombadil.infradead.org>
References: <20101016010952.GQ8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016010952.GQ8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a7f8388e accidentally removed it...

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/m32r/kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index 7bbe386..cc36fe1 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -28,6 +28,8 @@
 
 #define DEBUG_SIG 0
 
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
 asmlinkage int
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		unsigned long r2, unsigned long r3, unsigned long r4,
-- 
1.7.3.1

