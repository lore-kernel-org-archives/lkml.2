Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2F2Sc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab2F2Sc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:32:58 -0400
Message-ID: <4FEDF49A.9020907@redhat.com>
Date: Fri, 29 Jun 2012 14:31:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 15/40] autonuma: knuma_migrated per NUMA node queues
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-16-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-16-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 2427706..d53b26a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -697,6 +697,12 @@ typedef struct pglist_data {
>   	struct task_struct *kswapd;
>   	int kswapd_max_order;
>   	enum zone_type classzone_idx;
> +#ifdef CONFIG_AUTONUMA
> +	spinlock_t autonuma_lock;
> +	struct list_head autonuma_migrate_head[MAX_NUMNODES];
> +	unsigned long autonuma_nr_migrate_pages;
> +	wait_queue_head_t autonuma_knuma_migrated_wait;
> +#endif
>   } pg_data_t;
>
>   #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)

Once again, the data structure could use documentation.

What are these things for?

-- 
All rights reversed
