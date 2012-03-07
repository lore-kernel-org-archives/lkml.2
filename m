Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2CGVbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:31:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56731 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2CGVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:31:45 -0500
Date: Wed, 7 Mar 2012 13:31:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Wang Sheng-Hui <shhuiw@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb.c: cleanup to use long vars instead of int
 in region_count
In-Reply-To: <4EE6F24B.7050204@gmail.com>
Message-ID: <alpine.DEB.2.00.1203071331150.15255@chino.kir.corp.google.com>
References: <4EE6F24B.7050204@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Wang Sheng-Hui wrote:

> args f & t and fields from & to of struct file_region are defined
> as long. Use long instead of int to type the temp vars.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  mm/hugetlb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index dae27ba..e666287 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -195,8 +195,8 @@ static long region_count(struct list_head *head, long f, long t)
>  
>  	/* Locate each segment we overlap with, and count that overlap. */
>  	list_for_each_entry(rg, head, link) {
> -		int seg_from;
> -		int seg_to;
> +		long seg_from;
> +		long seg_to;
>  
>  		if (rg->to <= f)
>  			continue;

Acked-by: David Rientjes <rientjes@google.com>

Andrew, it looks like this never made it to linux-next.
