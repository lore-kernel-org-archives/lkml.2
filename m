Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2FNQzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:55:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35969 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab2FNQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:47 -0400
Date: Thu, 14 Jun 2012 12:44:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] staging: zsmalloc: fix uninit'ed variable warning
Message-ID: <20120614164409.GB333@phenom.dumpdata.com>
References: <1339621422-8449-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339621422-8449-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 04:03:42PM -0500, Seth Jennings wrote:
> This patch fixes an uninitialized variable warning in
> alloc_zspage().  It also fixes the secondary issue of
> prev_page leaving scope on each loop iteration.  The only
> reason this ever worked was because prev_page was occupying
> the same space on the stack on each iteration.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index fb54a9b..4af3dd6 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -400,7 +400,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
>  static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
>  {
>  	int i, error;
> -	struct page *first_page = NULL;
> +	struct page *first_page = NULL, *uninitialized_var(prev_page);
>  
>  	/*
>  	 * Allocate individual pages and link them together as:
> @@ -415,7 +415,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
>  	 */
>  	error = -ENOMEM;
>  	for (i = 0; i < class->pages_per_zspage; i++) {
> -		struct page *page, *prev_page;
> +		struct page *page;
>  
>  		page = alloc_page(flags);
>  		if (!page)
> -- 
> 1.7.9.5
