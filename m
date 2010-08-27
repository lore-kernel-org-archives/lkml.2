Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0H0Jnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57960 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab0H0Jns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pSRX7xSnGZylbRxvT9WjSUNnHLeGhVawjHLSdrpoDoPNnV5iw7kjQ3vifDYyfGKOjJ
         zOo2OfHjdjq7vvKRfmShLOEn15FX1UezkvIBY6IByRroqXybEge1eZ2Vc+yq7CrVifIc
         bNbpRhBi3kFWYrAqGYHtqdNXdU7qAtg3wmsJM=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [RFC PATCH 18/43] ptrace, ia64: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:04 +0900
Message-Id: <1282902149-12991-19-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/kernel/ptrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index 7c7909f..8848f43 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1177,7 +1177,8 @@ ptrace_disable (struct task_struct *child)
 }
 
 long
-arch_ptrace (struct task_struct *child, long request, long addr, long data)
+arch_ptrace (struct task_struct *child, long request,
+	     unsigned long addr, unsigned long data)
 {
 	switch (request) {
 	case PTRACE_PEEKTEXT:
-- 
1.7.2.2

