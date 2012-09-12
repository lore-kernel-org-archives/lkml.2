Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2ILT3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:29:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2ILT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:29:00 -0400
Date: Wed, 12 Sep 2012 12:28:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@intel.com>, Matthew Wilcox <willy@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/3 v2] mm: Batch unmapping of file mapped pages in
 shrink_page_list
Message-Id: <20120912122858.8642e382.akpm@linux-foundation.org>
In-Reply-To: <1347293965.9977.71.camel@schen9-DESK>
References: <1347293965.9977.71.camel@schen9-DESK>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012 09:19:25 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> @@ -1014,6 +1090,9 @@ keep_lumpy:

I worry that your tree has the label "keep_lumpy" in it!  Are you
developing against recent kernels?

>  		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
>  	}
>  
> +	nr_reclaimed += __remove_mapping_batch(&unmap_pages, &ret_pages,
> +					       &free_pages);
> +
>  	/*
>  	 * Tag a zone as congested if all the dirty pages encountered were
>  	 * backed by a congested BDI. In this case, reclaimers should just
> 
