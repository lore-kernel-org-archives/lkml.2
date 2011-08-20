Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1HTNZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 09:25:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54302 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1HTNZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 09:25:21 -0400
Message-ID: <4E4FB5A9.700@gmail.com>
Date: Sat, 20 Aug 2011 21:24:57 +0800
From: Zhao Jin <cronozhj@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: trivial: remove unnecessary get_order in free_thread_info
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Jin <cronozhj@gmail.com>

Because THREAD_SIZE is defined as PAGE_SIZE << THREAD_ORDER on x86, the 
call of get_order(THREAD_SIZE) can be replaced with THREAD_ORDER.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
---
  arch/x86/kernel/process.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..b9b3b1a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -49,7 +49,7 @@ void free_thread_xstate(struct task_struct *tsk)
  void free_thread_info(struct thread_info *ti)
  {
      free_thread_xstate(ti->task);
-    free_pages((unsigned long)ti, get_order(THREAD_SIZE));
+    free_pages((unsigned long)ti, THREAD_ORDER);
  }

  void arch_task_cache_init(void)
-- 
1.7.4.1

