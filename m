Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2EAW6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:58:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2EAW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:58:09 -0400
Date: Tue, 1 May 2012 15:57:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 05/11] mm: swap: Implement generic handler for
 swap_activate
Message-Id: <20120501155747.368a1d36.akpm@linux-foundation.org>
In-Reply-To: <1334578675-23445-6-git-send-email-mgorman@suse.de>
References: <1334578675-23445-1-git-send-email-mgorman@suse.de>
	<1334578675-23445-6-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 13:17:49 +0100
Mel Gorman <mgorman@suse.de> wrote:

> The version of swap_activate introduced is sufficient for swap-over-NFS
> but would not provide enough information to implement a generic handler.
> This patch shuffles things slightly to ensure the same information is
> available for aops->swap_activate() as is available to the core.
> 
> No functionality change.
> 
> ...
>
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -587,6 +587,8 @@ typedef struct {
>  typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
>  		unsigned long, unsigned long);
>  
> +struct swap_info_struct;

Please put forward declarations at top-of-file.  To prevent accidental
duplication later on.

>  struct address_space_operations {
>  	int (*writepage)(struct page *page, struct writeback_control *wbc);
>  	int (*readpage)(struct file *, struct page *);
>
> ...
>
> --- a/mm/page_io.c
> +++ b/mm/page_io.c

Have you tested all this code with CONFIG_SWAP=n?

Have you sought to minimise additional new code when CONFIG_SWAP=n?


