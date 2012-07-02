Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2GBEuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:50:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab2GBEtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:49:45 -0400
Message-ID: <4FF1283E.3010704@redhat.com>
Date: Mon, 02 Jul 2012 00:49:02 -0400
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
Subject: Re: [PATCH 31/40] autonuma: reset autonuma page data when pages are
 freed
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-32-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-32-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
> When pages are freed abort any pending migration. If knuma_migrated
> arrives first it will notice because get_page_unless_zero would fail.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
> ---
>   mm/page_alloc.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 48eabe9..841d964 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -615,6 +615,10 @@ static inline int free_pages_check(struct page *page)
>   		bad_page(page);
>   		return 1;
>   	}
> +	autonuma_migrate_page_remove(page);
> +#ifdef CONFIG_AUTONUMA
> +	page->autonuma_last_nid = -1;
> +#endif

Should these both be under the #ifdef ?

-- 
All rights reversed
