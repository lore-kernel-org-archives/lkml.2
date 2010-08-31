Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0HaJXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:23:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:33336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab0HaJXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:23:47 -0400
Message-ID: <4C7CC9E0.20501@kernel.org>
Date: Tue, 31 Aug 2010 11:22:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: caiqian@redhat.com
CC: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <2044609874.1606211283216015254.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <2044609874.1606211283216015254.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 09:22:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks for verifyiing.  Can you please apply this patch on top and
check that those debug messages go away?

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c8183b2..7855429 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -196,7 +196,7 @@ typedef cpumask_var_t mayday_mask_t;
 	cpumask_test_and_set_cpu((cpu), (mask))
 #define mayday_clear_cpu(cpu, mask)		cpumask_clear_cpu((cpu), (mask))
 #define for_each_mayday_cpu(cpu, mask)		for_each_cpu((cpu), (mask))
-#define alloc_mayday_mask(maskp, gfp)		alloc_cpumask_var((maskp), (gfp))
+#define alloc_mayday_mask(maskp, gfp)		zalloc_cpumask_var((maskp), (gfp))
 #define free_mayday_mask(mask)			free_cpumask_var((mask))
 #else
 typedef unsigned long mayday_mask_t;
