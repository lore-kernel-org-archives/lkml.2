Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0H0Jqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:46:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0H0Jof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GMjSb+G843wHzSqapfbolsjM3DS8oRQNhSPpnFN+fIZgN/XNOFYKIUwUqk43hWyMdA
         EPCFeMoQX53/787FdmhsPqJCq6smx0EOlgFK5+Rc7zQdX2IIn4tM+R41zPA16T7uRy1/
         CFJW9Sfa/81b9Wo4mdRTa+DwMDsmrqMHUrSWM=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [RFC PATCH 33/43] ptrace, s390: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:19 +0900
Message-Id: <1282902149-12991-34-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/ptrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 83339d3..019bb71 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -343,7 +343,8 @@ poke_user(struct task_struct *child, addr_t addr, addr_t data)
 	return __poke_user(child, addr, data);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	ptrace_area parea; 
 	int copied, ret;
-- 
1.7.2.2

