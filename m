Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404Ab2EVUqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:46:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2EVUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:45:59 -0400
Date: Tue, 22 May 2012 13:45:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: cl@linux.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com,
        rientjes@google.com, adobriyan@gmail.com, mel@csn.ul.ie
Subject: Re: [PATCH] hugetlb: fix resv_map leak in error path
Message-Id: <20120522134558.49255899.akpm@linux-foundation.org>
In-Reply-To: <20120521202814.E01F0FE1@kernel>
References: <20120521202814.E01F0FE1@kernel>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 13:28:14 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> When called for anonymous (non-shared) mappings,
> hugetlb_reserve_pages() does a resv_map_alloc().  It depends on
> code in hugetlbfs's vm_ops->close() to release that allocation.
> 
> However, in the mmap() failure path, we do a plain unmap_region()
> without the remove_vma() which actually calls vm_ops->close().
> 
> This is a decent fix.  This leak could get reintroduced if
> new code (say, after hugetlb_reserve_pages() in
> hugetlbfs_file_mmap()) decides to return an error.  But, I think
> it would have to unroll the reservation anyway.

How far back does this bug go?  The patch applies to 3.4 but gets
rejects in 3.3 and earlier.

> This hasn't been extensively tested.  Pretty much compile and
> boot tested along with Christoph's test case:
> 
> 	http://marc.info/?l=linux-mm&m=133728900729735

That isn't my favoritest ever changelog text :(
