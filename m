Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2EVHMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:12:32 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55831 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2EVHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:12:30 -0400
Message-ID: <4FBB3C3B.3090202@linux.vnet.ibm.com>
Date: Tue, 22 May 2012 09:11:55 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/2] sched: readd FAIR_SLEEPERS feature
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com> <1337615137-55111-2-git-send-email-schwidefsky@de.ibm.com>
In-Reply-To: <1337615137-55111-2-git-send-email-schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12052207-1948-0000-0000-000001DD70C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/21/2012 05:45 PM, Martin Schwidefsky wrote:
[...]
> --- a/kernel/sched/features.h
> +++ b/kernel/sched/features.h
> @@ -1,3 +1,12 @@
> +#ifdef CONFIG_SCHED_FAIR_SLEEPERS
> +/*
> + * Disregards a certain amount of sleep time (sched_latency_ns) and
> + * considers the task to be running during that period. This gives it
> + * a service deficit on wakeup, allowing it to run sooner.
> + */
> +SCHED_FEAT(FAIR_SLEEPERS, false)
> +#endif
> +
>   /*
>    * Only give sleepers 50% of their service deficit. This allows
>    * them to run sooner, but does not allow tons of sleepers to

This would be right for s390, but a change to every other architecture.
As far as I know s390 had custom patches in any distribution supported 
on s390 to set the default to false (like in your patch), but the 
upstream default for every other architecture was true.

I think the patch could look like this to make all happy:
...
+#ifndef CONFIG_S390
+ SCHED_FEAT(FAIR_SLEEPERS, true)
+#else
+SCHED_FEAT(FAIR_SLEEPERS, false)
...


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance

