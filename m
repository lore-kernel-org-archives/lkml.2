Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2EATCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:02:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2EATCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:02:49 -0400
Date: Tue, 1 May 2012 12:02:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] mm + fs: prepare for non-page entries in page cache
Message-Id: <20120501120246.83d2ce28.akpm@linux-foundation.org>
In-Reply-To: <1335861713-4573-3-git-send-email-hannes@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
	<1335861713-4573-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 May 2012 10:41:50 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -544,8 +544,7 @@ static void evict(struct inode *inode)
>  	if (op->evict_inode) {
>  		op->evict_inode(inode);
>  	} else {
> -		if (inode->i_data.nrpages)
> -			truncate_inode_pages(&inode->i_data, 0);
> +		truncate_inode_pages(&inode->i_data, 0);

Why did we lose this optimisation?
