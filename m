Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2F2UWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:22:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2F2UV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:21:58 -0400
Date: Fri, 29 Jun 2012 13:21:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: CONFIG_HAVE_MEMBLOCK_NODE ->
 CONFIG_HAVE_MEMBLOCK_NODE_MAP
Message-Id: <20120629132157.0f543593.akpm@linux-foundation.org>
In-Reply-To: <1341000877-12068-1-git-send-email-rabin@rab.in>
References: <1341000877-12068-1-git-send-email-rabin@rab.in>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012 01:44:37 +0530
Rabin Vincent <rabin@rab.in> wrote:

> 0ee332c14518699 ("memblock: Kill early_node_map[]") wanted to replace
> CONFIG_ARCH_POPULATES_NODE_MAP with CONFIG_HAVE_MEMBLOCK_NODE_MAP but
> ended up replacing one occurence with a reference to the non-existent
> symbol CONFIG_HAVE_MEMBLOCK_NODE.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
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
>  #else
>  	return 0;

Huh.  I wonder why nobody noticed.
