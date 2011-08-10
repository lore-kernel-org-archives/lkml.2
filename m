Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1HJPQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:16:04 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:61603 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab1HJPQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:16:00 -0400
X-AuditID: 12074423-b7b31ae000000a3c-1e-4e42a0b28b30
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/3] x86-64: Wire up getcpu syscall
Date: Wed, 10 Aug 2011 11:15:31 -0400
Message-Id: <6b19f55bdb06a0c32c2fa6dba9b6f222e1fde999.1312988155.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312988155.git.luto@mit.edu>
References: <cover.1312988155.git.luto@mit.edu>
In-Reply-To: <cover.1312988155.git.luto@mit.edu>
References: <cover.1312988155.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsUixG6nrrtpgZOfQccieYu+K0fZLY5c+85u
	8XnDPzaLaRvFLV79Kbe4vGsOm8WK852sFlsuNbNaPOp7y27xY8NjVgcuj++tfSwet9r+MHvM
	3/mR0WPnrLvsHptWdbJ5nJjxm8Xj8yY5j1mzDjN5nGj5whrAGcVlk5Kak1mWWqRvl8CVcfjZ
	V+aCC+wVTzadYmtgXM/WxcjJISFgIvFm3wkmCFtM4sI9kDgXh5DAPkaJibtmQDkbGCW+rl3I
	DOE8Y5J4+qobrJ1NQEWiY+kDoHYODhEBIYmld+tAapgFNjJJNCx4zggSFxYwlni8LBiknEVA
	VaL30Ul2EJtXIEhiS9NtFojNchJHLj8Hu4JTwEBi+pmnjCC2kIC+xPsJd9hxiU9gFFjAyLCK
	UTYlt0o3NzEzpzg1Wbc4OTEvL7VI10wvN7NELzWldBMjOOBdlHcw/jmodIhRgINRiYf3xjJH
	PyHWxLLiytxDjJIcTEqivP3znfyE+JLyUyozEosz4otKc1KLDzFKcDArifBKzQPK8aYkVlal
	FuXDpKQ5WJTEeWV2OvgJCaQnlqRmp6YWpBbBZGU4OJQkeG+CDBUsSk1PrUjLzClBSDNxcIIM
	5wEazr4AZHhxQWJucWY6RP4Uo6KUOO9zkGYBkERGaR5cLywhvWIUB3pFmFcApJ0HmMzgul8B
	DWYCGlx/xwFkcEkiQkqqgVF4o+6zG1w/b6yVNolZqsNtKLDnx/FAhlcq2WzsKgu2sGediJ78
	gv29D5sxZ/G1BV+j58Wc8Qz1W/7+pKmS3K5nm8TmVd1rms86021+2UKJRn3lqbyJ7Z4BS1Ud
	sg2iJ9bUfGi327A/8exEt8r731RrjXY+ClZZudH97pNDTgIvKid/ctixy1SJpTgj0VCLuag4
	EQCBfjWAIwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getcpu is available as a vdso entry and an emulated vsyscall.
Programs that for some reason don't want to use the vdso should
still be able to call getcpu without relying on the slow emulated
vsyscall.  It costs almost nothing to expose it as a real syscall.

We also need this for the following patch in vsyscall=native mode.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/unistd_64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 705bf13..d92641c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -681,6 +681,8 @@ __SYSCALL(__NR_syncfs, sys_syncfs)
 __SYSCALL(__NR_sendmmsg, sys_sendmmsg)
 #define __NR_setns				308
 __SYSCALL(__NR_setns, sys_setns)
+#define __NR_getcpu				309
+__SYSCALL(__NR_getcpu, sys_getcpu)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
-- 
1.7.6

