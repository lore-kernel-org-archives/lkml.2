Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab2F2UVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:21:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2F2UVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:21:43 -0400
Date: Fri, 29 Jun 2012 13:21:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: CONFIG_HAVE_MEMBLOCK_NODE ->
 CONFIG_HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20120629202139.GD21048@google.com>
References: <1341000877-12068-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341000877-12068-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 01:44:37AM +0530, Rabin Vincent wrote:
> 0ee332c14518699 ("memblock: Kill early_node_map[]") wanted to replace
> CONFIG_ARCH_POPULATES_NODE_MAP with CONFIG_HAVE_MEMBLOCK_NODE_MAP but
> ended up replacing one occurence with a reference to the non-existent
> symbol CONFIG_HAVE_MEMBLOCK_NODE.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Please add Cc: stable@vger.kernel.org.

 Acked-by: Tejun Heo <tj@kernel.org>

> ---
>  include/linux/mmzone.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 2427706..1d0a9a3 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -773,7 +773,7 @@ extern int movable_zone;
>  
>  static inline int zone_movable_is_highmem(void)
>  {
> -#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
> +#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
>  	return movable_zone == ZONE_HIGHMEM;

This probably has been doing something weird to 32bit machines w/
memory hotplug configured (which probably are extremely rare).  It
would be nice if the patch description explained what behavior it
actually fixes.  How did you find this?  From config check util or did
you actually see something broken?

Thanks.

-- 
tejun
