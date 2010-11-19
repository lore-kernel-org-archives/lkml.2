Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0KSPFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:05:18 -0500
Received: from mail.wdtv.com ([66.118.69.84]:52692 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0KSPFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:05:16 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Jordi Pujol <jordipujolp@gmail.com>
Subject: Re: Galbraith patch
Date: Fri, 19 Nov 2010 10:05:12 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
References: <201011191509.49586.jordipujolp@gmail.com>
In-Reply-To: <201011191509.49586.jordipujolp@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191005.12189.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Jordi Pujol wrote:
>Hello,
>
>it requires a little modification,
>
>CONFIG_SCHED_DEBUG should not be a condition to create autogroup in
>structure task_group
>
>remove
>    && defined(CONFIG_SCHED_DEBUG)
>in the following conditional:
>
>+++ linux-2.6.36/kernel/sched.c
>@@ -78,6 +78,7 @@
>
> #include "sched_cpupri.h"
> #include "workqueue_sched.h"
>+#include "sched_autogroup.h"
>
> #define CREATE_TRACE_POINTS
> #include <trace/events/sched.h>
>@@ -268,6 +269,10 @@ struct task_group {
> 	struct task_group *parent;
> 	struct list_head siblings;
> 	struct list_head children;
>+
>+#if (defined(CONFIG_SCHED_AUTOGROUP) && defined(CONFIG_SCHED_DEBUG))
>+	struct autogroup *autogroup;
>+#endif
> };
>
>Kind,
>
>Jordi Pujol

Thanks Jordi, but my last attempted build, using only the last 2 patches 
that Mike posted on a fresh unpack of 2.6.36, couldn't get past stage 2 of 
the modules build, it kept squawking about all the IR control stuff that is 
not even configured to be built.

I wonder how long it will take to get work this into mainline?

Along the same line, how does this compare to CK's bfs patch?

>Live never ending Tale
>GNU/Linux Live forever!
>http://livenet.selfip.com


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"What's the use of a good quotation if you can't change it?"
		-- The Doctor
