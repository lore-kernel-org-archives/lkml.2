Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2FHH35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:29:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58436 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2FHH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:29:55 -0400
Message-ID: <4FD1A9E8.9060608@vflare.org>
Date: Fri, 08 Jun 2012 00:29:44 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH] zram: remove special handle of uncompressed page
References: <1339137567-29656-1-git-send-email-minchan@kernel.org> <1339137567-29656-3-git-send-email-minchan@kernel.org>
In-Reply-To: <1339137567-29656-3-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:39 PM, Minchan Kim wrote:

> xvmalloc can't handle PAGE_SIZE page so that zram have to
> handle it specially but zsmalloc can do it so let's remove
> unnecessary special handling code.
> 
> Quote from Nitin
> "I think page vs handle distinction was added since xvmalloc could not
> handle full page allocation. Now that zsmalloc allows full page
> allocation, we can just use it for both cases. This would also allow
> removing the ZRAM_UNCOMPRESSED flag. The only downside will be slightly
> slower code path for full page allocation but this event is anyways
> supposed to be rare, so should be fine."
> 
> 1. This patch reduces code very much.
> 
>  drivers/staging/zram/zram_drv.c   |  104 +++++--------------------------------
>  drivers/staging/zram/zram_drv.h   |   17 +-----
>  drivers/staging/zram/zram_sysfs.c |    6 +--
>  3 files changed, 15 insertions(+), 112 deletions(-)
> 
> 2. change pages_expand with bad_compress so it can count
>    bad compression(above 75%) ratio.
> 
> 3. remove zobj_header which is for back-reference for defragmentation
>    because firstly, it's not used at the moment and zsmalloc can't handle
>    bigger size than PAGE_SIZE so zram can't do it any more without redesign.
> 
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c   |  104 +++++--------------------------------
>  drivers/staging/zram/zram_drv.h   |   17 +-----
>  drivers/staging/zram/zram_sysfs.c |    6 +--
>  3 files changed, 15 insertions(+), 112 deletions(-)
> 


I tried hard to figure out if these three things could be separated out
as separate patches but looks like that would make individual patches
unnecessarily messy.

Perhaps we should also add a fastpath for PAGE_SIZE'd objects in
zsmalloc but that's probably something for future work.


Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
