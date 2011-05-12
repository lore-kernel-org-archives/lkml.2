Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1ELRHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:07:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62531 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab1ELRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vg471QgxR4DRcOx1d6v/1GmBfedat7tkBbqQaeP/rfSAgEeYOeOmi1BrogC8O3K710
         l9UHfnMjGYd+Mk7y8OFiKzTU0p+kpELqcfPZDSXCJldMGvOhj0pONhVlbLK0olzjUYDv
         9QF+YMWc5hBeF1fKyfwI1IUUOaPoR50ZGqWVc=
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86, paravirt: Avoid unused by set variables in rdmsr
Date: Thu, 12 May 2011 14:08:03 -0300
Message-Id: <1305220083-22620-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like 5f755293 (x86, gcc-4.6: Avoid unused by set variables in
rdmsr) this patch silences GCC warnings about "set but not used
variables" in paravirt.h.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 arch/x86/include/asm/paravirt.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ebbc4d8..1e02d57 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -147,8 +147,8 @@ static inline int paravirt_wrmsr_regs(u32 *regs)
 do {						\
 	int _err;				\
 	u64 _l = paravirt_read_msr(msr, &_err);	\
-	val1 = (u32)_l;				\
-	val2 = _l >> 32;			\
+	(void)((val1) = (u32)_l);		\
+	(void)((val2) = (u32)(_l >> 32));	\
 } while (0)
 
 #define wrmsr(msr, val1, val2)			\
-- 
1.7.5.1

