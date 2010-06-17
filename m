Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0FQNpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:45:47 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:54377 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759762Ab0FQNpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:45:45 -0400
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 09:45:45 EDT
Date: Thu, 17 Jun 2010 15:25:54 +0200
From: Jesper Nilsson <jesper@jni.nu>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: MIPS: return after handling coprocessor 2 exception
Message-ID: <20100617132554.GB24162@jni.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-Originating-IP: 83.249.211.213
X-Scan-Result: No virus found in message 1OPF6T-0007Ym-9I.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OPF6T-0007Ym-9I cfb3430c4e9b0e02823d802f44a78c9a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaking here dropped us to the default code which always sends
a SIGILL to the current process, no matter what the CU2 notifier says.

Signed-off-by: Jesper Nilsson <jesper@jni.nu>
---
 traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 8bdd6a6..8527808 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -976,7 +976,7 @@ asmlinkage void do_cpu(struct pt_regs *regs)
 
 	case 2:
 		raw_notifier_call_chain(&cu2_chain, CU2_EXCEPTION, regs);
-		break;
+		return;
 
 	case 3:
 		break;

/^JN - Jesper Nilsson
--
                  Jesper Nilsson -- jesper_at_jni.nu
