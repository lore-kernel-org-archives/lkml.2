Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0J0J72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:59:28 -0400
Received: from ozlabs.org ([203.10.76.45]:54582 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0J0J70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:59:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: x86@kernel.org
Subject: [PATCH] cpumask: remove obsolete cpu operation in x86/kernel/apb_timer.c
Date: Wed, 27 Oct 2010 20:29:21 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010272029.22150.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first_cpu -> cpumask_first

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/apb_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -431,7 +431,7 @@ static void apbt_set_mode(enum clock_eve
 
 	timer_num = adev->num;
 	pr_debug("%s CPU %d timer %d mode=%d\n",
-		 __func__, first_cpu(*evt->cpumask), timer_num, mode);
+		 __func__, cpumask_first(evt->cpumask), timer_num, mode);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
