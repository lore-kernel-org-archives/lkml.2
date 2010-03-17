Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0CQOZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:25:14 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4403 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0CQOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:25:12 -0400
Subject: Re: [PATCH 3/5] tmpfs: handle MPOL_LOCAL mount option properly
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       stable@kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <20100316145022.4C4E.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org>
	 <20100316143406.4C45.A69D9226@jp.fujitsu.com>
	 <20100316145022.4C4E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Mar 2010 10:25:08 -0400
Message-Id: <1268835908.4773.47.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 14:51 +0900, KOSAKI Motohiro wrote:
> commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
> shmem_sb_info) added mpol=local mount option. but its feature is
> broken since it was born. because such code always return 1 (i.e.
> mount failure).
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: <stable@kernel.org>

Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

> ---
>  mm/mempolicy.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3f77062..5c197d5 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2212,6 +2212,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  		if (nodelist)
>  			goto out;
>  		mode = MPOL_PREFERRED;
> +		err = 0;
>  		break;
>  	case MPOL_DEFAULT:
>  		/*

