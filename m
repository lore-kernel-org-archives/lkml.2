Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1EaNQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:16:34 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:58630 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab1EaNQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:16:32 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-4d-4de4e9ef8617
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 01/10] x86-64: Fix alignment of jiffies variable
Date: Tue, 31 May 2011 09:15:55 -0400
Message-Id: <4728c7db2fc6c5029434f75f956a4122451db744.1306847455.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsUixCmqrfv+5RNfg+btXBZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZfw6cIm94B1rxfaLK5gbGP+wdDFy
	ckgImEhMfbyVFcIWk7hwbz1bFyMXh5DAPkaJzp3fGUESQgIbGCWWHauFSDxjknj3fj8TSIJN
	QEWiY+kDIJuDQ0RAX+LqZ0aQGmaBSSwSh/+eBtsgLOAssfDrSmYQm0VAVeLi/2NgcV6BIInO
	6TPYITYrSFy5Mg8szilgING8cg0bxGJ9iftPrjDjEp/AKLCAkWEVo2xKbpVubmJmTnFqsm5x
	cmJeXmqRrpFebmaJXmpK6SZGcNRI8u5gfHdQ6RCjAAejEg8v6/7HvkKsiWXFlbmHGCU5mJRE
	eWWAMSfEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhPcbH1CONyWxsiq1KB8mJc3BoiTOO1NS3VdI
	ID2xJDU7NbUgtQgmK8PBoSTBmwIyVLAoNT21Ii0zpwQhzcTBCTKcB2h4KEgNb3FBYm5xZjpE
	/hSjLkfj2h0HGYVY8vLzUqXEebNAigRAijJK8+DmwJLdK0ZxoLeEeb1BqniAiRJu0iugJUxA
	S3rfPQRZUpKIkJJqYLSTKiyye1y9SCjBfsZJZ+dGuV1d9xVtRHbIlxa1NbIzbNvSfio9xprL
	SnzHy6vex2Xa2JR9zrBYW1aX//jltvhY/oZXPrz9OwI+XJHieLzqVobNzik/tfu5c80KTzC4
	90UEz9Qpvh385MDjtfYmlsu7by3OkZTMNc8t/Rl48n7o1ttBsXZPlFiKMxINtZiLihMBSqLt
	y1EDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's declared __attribute__((aligned(16)) but it's explicitly not
aligned.  This is probably harmless but it's a bit embarrassing.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vvar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 341b355..a4eaca4 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -45,7 +45,7 @@
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(8, int, vgetcpu_mode)
+DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
-- 
1.7.5.1

