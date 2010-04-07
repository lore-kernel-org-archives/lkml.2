Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0DGAGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:06:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932211Ab0DGAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:23 -0400
Date: Tue, 6 Apr 2010 17:05:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] Allow CONFIG_MIGRATION to be set without
 CONFIG_NUMA or memory hot-remove
Message-Id: <20100406170532.56c71031.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-5-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-5-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:38 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> CONFIG_MIGRATION currently depends on CONFIG_NUMA or on the architecture
> being able to hot-remove memory. The main users of page migration such as
> sys_move_pages(), sys_migrate_pages() and cpuset process migration are
> only beneficial on NUMA so it makes sense.
> 
> As memory compaction will operate within a zone and is useful on both NUMA
> and non-NUMA systems, this patch allows CONFIG_MIGRATION to be set if the
> user selects CONFIG_COMPACTION as an option.
> 
> ...
>
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -172,6 +172,16 @@ config SPLIT_PTLOCK_CPUS
>  	default "4"
>  
>  #
> +# support for memory compaction
> +config COMPACTION
> +	bool "Allow for memory compaction"
> +	def_bool y
> +	select MIGRATION
> +	depends on EXPERIMENTAL && HUGETLBFS && MMU
> +	help
> +	  Allows the compaction of memory for the allocation of huge pages.

Seems strange to depend on hugetlbfs.  Perhaps depending on
HUGETLB_PAGE would be more logical.

But hang on.  I wanna use compaction to make my order-4 wireless skb
allocations work better!  Why do you hate me?


