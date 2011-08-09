Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1HIO21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:28:27 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:56630 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab1HIO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:28:25 -0400
X-AuditID: 12074423-b7b31ae000000a3c-be-4e41440b5530
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Andy Lutomirski <luto@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 3/4] x86-64: Wire up getcpu syscall
Date: Tue,  9 Aug 2011 10:27:49 -0400
Message-Id: <6d3b65b43153f765fd995a848a6913991d507172.1312899174.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsUixG6nosvt4uhnMPuXiEXflaPsFkeufWe3
	+LzhH5vFtI3iFq/+lFtc3jWHzWLF+U5Wiy2Xmlkt/jXdYrF41PeW3eLHhsesDtwe31v7WDxu
	tf1h9pi/8yOjx85Zd9k9Fu95yeSxaVUnm8eJGb9ZPD5vkvOYNeswk8eJli+sAVxRXDYpqTmZ
	ZalF+nYJXBl/9j9nLuhir9g+fRJ7A+N31i5GDg4JAROJ3c+Nuhg5gUwxiQv31rOB2EIC+xgl
	OleWdzFyAdnrGSUWLWhkhHCeMklc2P+QBaSKTUBFomPpAyaQQSICQhJL79aB1DCD1DTP2c0M
	UiMsYCxxZtI7dpAaFgFViebbTCBhXoEgiYtHutggFstJHLn8HCzOKWAg8ePzXSaII/Ql1p+4
	iFN8AqPAAkaGVYyyKblVurmJmTnFqcm6xcmJeXmpRbpmermZJXqpKaWbGMER4KK8g/HPQaVD
	jAIcjEo8vJz8Dn5CrIllxZW5hxglOZiURHnNnB39hPiS8lMqMxKLM+KLSnNSiw8xSnAwK4nw
	pmsA5XhTEiurUovyYVLSHCxK4rwyO4EmCaQnlqRmp6YWpBbBZGU4OJQkeP1AhgoWpaanVqRl
	5pQgpJk4OEGG8wANr3ICGV5ckJhbnJkOkT/FqCglzhsF0iwAksgozYPrhSWoV4ziQK8I8+qD
	VPEAkxtc9yugwUxAg+vvOIAMLklESEk1MDL3KLRt+BnMtUWL7f7CumVx9ur336/MfdSwRsta
	cXV7L8/BnF/s4veKQ1duzZrl91Tl1XWGqxcX9T7Y4qG6LMfOKqlnv/TGd1tvxZSE5lbqBC0o
	3H1WY1fz/JvaE/Yt5WFbXbL5kpEto6WIkZLB9eOl3jbixlMOznd5rlKrOOdtANvjH0u32yux
	FGckGmoxFxUnAgCuaNR0KwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getcpu is available as a vdso entry and an emulated vsyscall.
Programs that for some reason don't want to use the vdso should
still be able to call getcpu without relying on the slow emulated
vsyscall.  It costs almost nothing to expose it as a real syscall.

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

