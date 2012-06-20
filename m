Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2FTPun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2FTPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:50:42 -0400
Message-ID: <4FE1F109.1060200@redhat.com>
Date: Wed, 20 Jun 2012 11:49:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 03/12] mm: Methods for teaching filesystems about PG_swapcache
 pages
References: <1340185081-22525-1-git-send-email-mgorman@suse.de> <1340185081-22525-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1340185081-22525-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 05:37 AM, Mel Gorman wrote:
> In order to teach filesystems to handle swap cache pages, three new
> page functions are introduced:
>
>    pgoff_t page_file_index(struct page *);
>    loff_t page_file_offset(struct page *);
>    struct address_space *page_file_mapping(struct page *);
>
> page_file_index() - gives the offset of this page in the file in
> PAGE_CACHE_SIZE blocks. Like page->index is for mapped pages, this
> function also gives the correct index for PG_swapcache pages.
>
> page_file_offset() - uses page_file_index(), so that it will give
> the expected result, even for PG_swapcache pages.
>
> page_file_mapping() - gives the mapping backing the actual page;
> that is for swap cache pages it will give swap_file->f_mapping.
>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel<riel@redhat.com>

