Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2CMAW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:47653 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab2CMAWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jan Beulich <JBeulich@novell.com>,
        Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 059/196] x86: Fix a bogus unwind annotation in lib/semaphore_32.S
Date: Mon, 12 Mar 2012 20:19:32 -0400
Message-Id: <1331598109-31424-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@novell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e938c287ea8d977e079f07464ac69923412663ce upstream.

'simple' would have required specifying current frame address
and return address location manually, but that's obviously not
the case (and not necessary) here.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D6D1082020000780003454C@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/lib/semaphore_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..f35eec7 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)
-- 
1.7.9.3

