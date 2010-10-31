Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0JaF4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 01:56:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62765 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0JaF4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 01:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Iq21JkDOqejcrWUtcO6xqVpmlBPyP39jlMZxyah+O/KDzW1Lieqj1oc0UVU9RrP6WK
         ZX123QPPNlRt8wwdGvaC+eArl2IrChymMozuGPqhXh3UcBgXbnP0YWVI6Xg3TejMTI5J
         IxKIcP7S+rDzUloprAaeAckTKAHdnObQzNqV4=
MIME-Version: 1.0
Date: Sun, 31 Oct 2010 11:56:02 +0600
Message-ID: <AANLkTi=T2JXDT=jYRED8jMGiWdxwUt5vJ-RG=pfRv9dS@mail.gmail.com>
Subject: [PATCH] sched: Remove redundant #ifdef.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove redundant #ifdef to wrap struct cpupri. root_domain structure
is declared under #ifdef CONFIG_SMP, no need to use #ifdef again
inside the structure.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus-36/kernel/sched.c	2010-10-21 02:30:22.000000000 +0600
+++ rakib-36/kernel/sched.c	2010-10-31 11:16:22.000000000 +0600
@@ -426,9 +426,7 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	atomic_t rto_count;
-#ifdef CONFIG_SMP
 	struct cpupri cpupri;
-#endif
 };

 /*
