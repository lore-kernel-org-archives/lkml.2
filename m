Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0IOPWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:22:25 -0400
Received: from xenotime.net ([72.52.115.56]:57431 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752497Ab0IOPWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:22:24 -0400
Date: Wed, 15 Sep 2010 08:22:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] ida: document IDA_BITMAP_LONGS calculation
Message-Id: <20100915082217.6bf82715.rdunlap@xenotime.net>
In-Reply-To: <1284554762-13278-1-git-send-email-namhyung@gmail.com>
References: <1284554762-13278-1-git-send-email-namhyung@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 21:46:01 +0900 Namhyung Kim wrote:

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

Might as well do:

#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long) - 1)

instead of repeating the 128.


> -#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
> +#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
>  
>  struct ida_bitmap {
>  	long			nr_busy;
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
