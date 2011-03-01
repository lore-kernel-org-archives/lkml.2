Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1CAO2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:28:09 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:49103 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab1CAO2I convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 1 Mar 2011 09:28:08 -0500
Message-Id: <4D6D1082020000780003454C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 01 Mar 2011 14:28:02 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: fix a bogus unwind annotation in
	 lib/semaphore_32.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'simple' would have required specifying current frame address and
return address location manually, but that's obviously not the case
(and not necessary) here.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/lib/semaphore_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.38-rc6/arch/x86/lib/semaphore_32.S
+++ 2.6.38-rc6-ix86-unwind-write_lock_failed/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)



