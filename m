Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0CQOSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:18:14 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:8651 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0CQOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:18:12 -0400
Subject: Re: [PATCH 2/5] tmpfs: mpol=bind:0 don't cause mount error.
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       stable@kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <20100316144929.4C4B.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org>
	 <20100316143406.4C45.A69D9226@jp.fujitsu.com>
	 <20100316144929.4C4B.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Mar 2010 10:17:17 -0400
Message-Id: <1268835437.4773.42.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 14:50 +0900, KOSAKI Motohiro wrote:
> Currently, following mount operation cause mount error.
> 
> % mount -t tmpfs -ompol=bind:0 none /tmp
> 
> Because commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
> shmem_sb_info) corrupted MPOL_BIND parse code.
> 
> This patch restore the needed one.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: <stable@kernel.org>

There's a trailing space in the patch, but except for that:

Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

> ---
>  mm/mempolicy.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 25a0c0f..3f77062 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2220,9 +2220,13 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  		if (!nodelist)
>  			err = 0;
>  		goto out;
> -	/*
> -	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
> -	 */
> +	case MPOL_BIND:
> +		/* 
trailing space      ^

> +		 * Insist on a nodelist
> +		 */
> +		if (!nodelist)
> +			goto out;
> +		err = 0;
>  	}
>  
>  	mode_flags = 0;

