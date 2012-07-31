Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2GaPcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:32:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34333 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2GaPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:32:41 -0400
Date: Tue, 31 Jul 2012 11:23:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, trivial@kernel.org
Subject: Re: [PATCH][TRIVIAL] mm/frontswap: fix uninit'ed variable warning
Message-ID: <20120731152332.GL4789@phenom.dumpdata.com>
References: <1343677664-26665-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343677664-26665-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 02:47:44PM -0500, Seth Jennings wrote:
> Fixes uninitialized variable warning on 'type' in frontswap_shrink().
> type is set before use by __frontswap_unuse_pages() called by
> __frontswap_shrink() called by frontswap_shrink() before use by
> try_to_unuse().

OK, applied.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
> Based on next-20120730
> 
>  mm/frontswap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index 6b3e71a..89dc399 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -292,7 +292,7 @@ static int __frontswap_shrink(unsigned long target_pages,
>  void frontswap_shrink(unsigned long target_pages)
>  {
>  	unsigned long pages_to_unuse = 0;
> -	int type, ret;
> +	int uninitialized_var(type), ret;
>  
>  	/*
>  	 * we don't want to hold swap_lock while doing a very
> -- 
> 1.7.9.5
