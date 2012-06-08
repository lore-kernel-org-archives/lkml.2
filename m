Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2FHHNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:13:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61827 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2FHHNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:13:14 -0400
Message-ID: <4FD1A5FE.7020305@vflare.org>
Date: Fri, 08 Jun 2012 00:13:02 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH v3] zsmalloc: zsmalloc: use unsigned long instead of void
 *
References: <1339137567-29656-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1339137567-29656-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:39 PM, Minchan Kim wrote:

> We should use unsigned long as handle instead of void * to avoid any
> confusion. Without this, users may just treat zs_malloc return value as
> a pointer and try to deference it.
> 
> This patch passed compile test(zram, zcache and ramster) and zram is
> tested on qemu.
> 
> changelog
>   * from v2
> 	- remove hval pointed out by Nitin
> 	- based on next-20120607
>   * from v1
> 	- change zcache's zv_create return value
> 	- baesd on next-20120604
> 
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zcache/zcache-main.c     |   12 ++++++------
>  drivers/staging/zram/zram_drv.c          |   16 ++++++++--------
>  drivers/staging/zram/zram_drv.h          |    2 +-
>  drivers/staging/zsmalloc/zsmalloc-main.c |   28 +++++++++++++---------------
>  drivers/staging/zsmalloc/zsmalloc.h      |    8 ++++----
>  5 files changed, 32 insertions(+), 34 deletions(-)
> 


Thanks for all these fixes and cleanups.

Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
