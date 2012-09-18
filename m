Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2IRLQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:16:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55445 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab2IRLQR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 18 Sep 2012 07:16:17 -0400
Message-Id: <5058741E020000780009C014@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 18 Sep 2012 12:16:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] x86: use tzcnt instead of bsf
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a relatively recent compiler change, make use of the fact
that for non-zero input BSF and TZCNT produce the same result, and that
CPUs not knowing of TZCNT will treat the instruction as BSF (i.e.
ignore what looks like a REP prefix to them). The assumption here is
that TZCNT would never have worse performance than BSF.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

---
v2: Do this unconditionally, and change title accordingly.

---
 arch/x86/include/asm/bitops.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.6-rc6/arch/x86/include/asm/bitops.h
+++ 3.6-rc6-x86-bsf-tzcnt/arch/x86/include/asm/bitops.h
@@ -355,7 +355,7 @@ static int test_bit(int nr, const volati
  */
 static inline unsigned long __ffs(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm("rep; bsf %1,%0"
 		: "=r" (word)
 		: "rm" (word));
 	return word;
@@ -369,7 +369,7 @@ static inline unsigned long __ffs(unsign
  */
 static inline unsigned long ffz(unsigned long word)
 {
-	asm("bsf %1,%0"
+	asm("rep; bsf %1,%0"
 		: "=r" (word)
 		: "r" (~word));
 	return word;



