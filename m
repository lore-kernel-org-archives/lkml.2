Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1EaOPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:15:00 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:45896 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab1EaOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:14:59 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-c6-4de4f7d8e9da
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
Subject: [PATCH v4 01/10] x86-64: Fix alignment of jiffies variable
Date: Tue, 31 May 2011 10:13:59 -0400
Message-Id: <ddaf914dc87f24cbd6ac071ae904448dbaf7fd54.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsUixCmqrHvj+xNfg10NchZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZfw6cIm94B1rxfaLK5gbGP+wdDFy
	ckgImEhcWXufHcIWk7hwbz1bFyMXh5DAPkaJpU2NjBDOBkaJ2R972CGcZ0wSbyZsYwJpYRNQ
	kehY+gDI5uAQEdCXuPoZrIFZYBKLxOG/p8FWCAs4Syz+vZsdpIZFQFWi7VgCSJhXIEji/Y8H
	bBCbFSSuXJkHVs4pYCCx/eoqRpByIaCRxz/o4hCewCiwgJFhFaNsSm6Vbm5iZk5xarJucXJi
	Xl5qka6xXm5miV5qSukmRnDESPLtYPx6UOkQowAHoxIPb/zBx75CrIllxZW5hxglOZiURHkr
	vj3xFeJLyk+pzEgszogvKs1JLT7EKMHBrCTC+40PKMebklhZlVqUD5OS5mBREuedKanuKySQ
	nliSmp2aWpBaBJOV4eBQkuDdCzJUsCg1PbUiLTOnBCHNxMEJMpwHaHghSA1vcUFibnFmOkT+
	FKMuR+PaHQcZhVjy8vNSpcR5v4IUCYAUZZTmwc2BJbpXjOJAbwnzPgap4gEmSbhJr4CWMAEt
	6X33EGRJSSJCSqqBcbqE3TZD6d+zVbImbVn1aMLdqTdcXk4Lvhe7IXdG1NQlr7jvrVZjkgxa
	ELVNc4bFcc1qu4Ce3NKO8Mfi5yqEN4myzo72a1i3ltWh1D37abDYjaC1yWzxlt3Wf/0V+b+K
	i4ds3rJa51bc/zWzzpZVNJ0wubl6v/cCQ9mrM1xlb134LWyXFJvBpsRSnJFoqMVcVJwIAD4S
	hVFPAwAA
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

