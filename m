Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922Ab0I1EBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:01:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33930 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0I1EBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:01:01 -0400
Date: Mon, 27 Sep 2010 21:00:43 -0700
Message-Id: <201009280400.o8S40h39029683@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86: constant_test_bit() fix
Cc: Alexander Chumachenko <ledest@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Shigorin <mike@osdn.org.ua>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 252a52aa4fa22a668f019e55b3aac3ff71ec1c29:

  Fix pktcdvd ioctl dev_minor range check (2010-09-27 16:29:06 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/urgent

Alexander Chumachenko (1):
      x86: Avoid 'constant_test_bit()' misoptimization due to cast to non-volatile

 arch/x86/include/asm/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 545776e..bafd80d 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -309,7 +309,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+		(addr[nr / BITS_PER_LONG])) != 0;
 }
 
 static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
