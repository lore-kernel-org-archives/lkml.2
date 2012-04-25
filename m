Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab2DYNfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:35:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51290 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2DYNfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:35:30 -0400
Message-ID: <4F97FD9D.9090105@vflare.org>
Date: Wed, 25 Apr 2012 09:35:25 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] zsmalloc: remove unnecessary type casting
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-6-git-send-email-minchan@kernel.org>
In-Reply-To: <1335334994-22138-6-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 02:23 AM, Minchan Kim wrote:

> Let's remove unnecessary type casting of (void *).
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index b7d31cc..ff089f8 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -644,8 +644,7 @@ void zs_free(struct zs_pool *pool, void *obj)
>  	spin_lock(&class->lock);
>  
>  	/* Insert this object in containing zspage's freelist */
> -	link = (struct link_free *)((unsigned char *)kmap_atomic(f_page)
> -							+ f_offset);
> +	link = (struct link_free *)(kmap_atomic(f_page)	+ f_offset);
>  	link->next = first_page->freelist;
>  	kunmap_atomic(link);
>  	first_page->freelist = obj;



Incrementing a void pointer looks weired and should not be allowed by C
compilers though gcc and clang seem to allow this without any warnings.
(fortunately C++ forbids incrementing void pointers)

So, we should keep this cast to unsigned char pointer to avoid relying
on a non-standard, compiler specific behavior.

Thanks,
Nitin

