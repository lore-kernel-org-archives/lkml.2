Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0IWLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:25:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab0IWLZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:25:56 -0400
Date: Thu, 23 Sep 2010 13:25:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ida: document IDA_BITMAP_LONGS calculation
In-Reply-To: <1283506698-21369-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.LNX.2.00.1009231325370.26813@pobox.suse.cz>
References: <1283506698-21369-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Namhyung Kim wrote:

> IDA_BITMAP_LONGS value is calculated take into account struct ida_bitmap
> not to waste memory space. Comment it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  include/linux/idr.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index e968db7..3f4b718 100644
> --- a/include/linux/idr.h
> +++ b/include/linux/idr.h
> @@ -117,10 +117,13 @@ void idr_init(struct idr *idp);
>  /*
>   * IDA - IDR based id allocator, use when translation from id to
>   * pointer isn't necessary.
> + *
> + * IDA_BITMAP_LONGS is calculated to be one less to accommodate
> + * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
>   */
>  #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
>  #define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
> -#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
> +#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
>  
>  struct ida_bitmap {
>  	long			nr_busy;

Tejun, any word on this patch? Doesn't seem to be present in linux-next.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
