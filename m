Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0FBACk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 20:02:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756094Ab0FBACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 20:02:39 -0400
Date: Tue, 1 Jun 2010 16:57:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       davem@davemloft.net, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
In-Reply-To: <20100601164603.39dfedf7.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006011651580.8175@i5.linux-foundation.org>
References: <25328.1274886067@redhat.com> <4BFE4203.5010803@kernel.org> <20100601164603.39dfedf7.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Andrew Morton wrote:
> 
> Please, always quote the patch title rather than a bare commit ID.  The
> usual form is
> 
>     fa4b9074cd8428958c2adf9dc0c831f46e27c193 ("buffer: make
>     invalidate_bdev() drain all percpu LRU add caches:)
> 
> The main reason for this is so that people can more reliably and simply
> identify the patch within a different tree.  I think.

Absolutely. Also, I think it's usually more readable to quote just the 
first 12 hex digits of the SHA1 - that's still going to be perfectly 
unique in any practical situation, and makes it way easier to flow the 
text to be readable.

> gaah.  Do we really want to add Yet Another Kernel Thread just for that
> dopey sysrq-U thing?

I do have to agree that it's disgusting. Can't we use an existing thread 
(slow-work?) or something like that?

		Linus
