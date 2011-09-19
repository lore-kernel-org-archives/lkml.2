Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1ISSa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:30:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:12177 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab1ISSa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49989431"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Eric Paris <eparis@redhat.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        kernel-hardening@lists.openwall.com
Subject: Re: [Security] [PATCH 2/2] taskstats: restrict access to user
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
	<BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
	<CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
Date: Mon, 19 Sep 2011 11:29:28 -0700
In-Reply-To: <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 19 Sep 2011 09:40:19 -0700")
Message-ID: <m2ipooe67r.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>  	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
> diff --git a/kernel/tsacct.c b/kernel/tsacct.c
> index 24dc60d9fa1f..110ca5a03bd6 100644
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -78,6 +78,7 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
>  
>  #define KB 1024

Needs to be 1024ULL, because the counters are 64bit.

>  #define MB (1024*KB)
> +#define KB_MASK (~(KB-1))

Otherwise you lose the upper 32bits here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
