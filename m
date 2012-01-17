Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2AQWvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:51:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab2AQWvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:51:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] PM / Hibernate: Correct additional page calculation
Date: Tue, 17 Jan 2012 23:54:49 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: Namhyung Kim <namhyung@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1326768189-13074-1-git-send-email-namhyung.kim@lge.com>
In-Reply-To: <1326768189-13074-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201172354.49708.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 17, 2012, Namhyung Kim wrote:
> The struct bm_block is allocated by chain_alloc(),
> so it'd better counting it in LINKED_PAGE_DATA_SIZE.

Yes, good catch, thanks!

I'm going to push this to Linus in the next round of fixes.

Thanks,
Rafael


> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  kernel/power/snapshot.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index cbe2c1441392..7196d3c023e1 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -812,7 +812,8 @@ unsigned int snapshot_additional_pages(struct zone *zone)
>  	unsigned int res;
>  
>  	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
> -	res += DIV_ROUND_UP(res * sizeof(struct bm_block), PAGE_SIZE);
> +	res += DIV_ROUND_UP(res * sizeof(struct bm_block),
> +			    LINKED_PAGE_DATA_SIZE);
>  	return 2 * res;
>  }
>  
> 

