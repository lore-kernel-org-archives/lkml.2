Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab2CGXvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:51:37 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19507 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab2CGXvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:51:36 -0500
Date: Thu, 8 Mar 2012 00:50:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: decode GFP flags in oom killer output.
In-Reply-To: <20120307233939.GB5574@redhat.com>
Message-ID: <alpine.LNX.2.00.1203080047120.21218@swampdragon.chaosbits.net>
References: <20120307233939.GB5574@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Dave Jones wrote:

> Decoding these flags by hand in oom reports is tedious,
> and error-prone.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff -durpN '--exclude-from=/home/davej/.exclude' -u src/git-trees/kernel/linux/include/linux/gfp.h linux-dj/include/linux/gfp.h
> --- linux/include/linux/gfp.h	2012-01-11 16:54:21.736395499 -0500
> +++ linux-dj/include/linux/gfp.h	2012-03-06 13:17:37.294692113 -0500
> @@ -10,6 +10,7 @@
>  struct vm_area_struct;
>  
>  /* Plain integer GFP bitmasks. Do not use this directly. */
> +/* Update mm/oom_kill.c gfp_flag_texts when adding to/changing this list */
>  #define ___GFP_DMA		0x01u
>  #define ___GFP_HIGHMEM		0x02u
>  #define ___GFP_DMA32		0x04u
> diff -durpN '--exclude-from=/home/davej/.exclude' -u src/git-trees/kernel/linux/mm/oom_kill.c linux-dj/mm/oom_kill.c
> --- linux/mm/oom_kill.c	2012-01-17 17:54:14.541881964 -0500
> +++ linux-dj/mm/oom_kill.c	2012-03-06 13:17:44.071680535 -0500
> @@ -416,13 +416,40 @@ static void dump_tasks(const struct mem_
>  	}
>  }
>  
> +static unsigned char *gfp_flag_texts[32] = {
> +	"DMA", "HIGHMEM", "DMA32", "MOVABLE",
> +	"WAIT", "HIGH", "IO", "FS",
> +	"COLD", "NOWARN", "REPEAT", "NOFAIL",
> +	"NORETRY", NULL, "COMP", "ZERO",
> +	"NOMEMALLOC", "HARDWALL", "THISNODE", "RECLAIMABLE",
> +	NULL, "NOTRACK", "NO_KSWAPD", "OTHER_NODE",
> +};

Hmm, there are 24 entries in this list, yet you allocate an array of size 
32 - why?
Shouldn't this just be 'static unsigned char *gfp_flag_texts[] = {...}' 
and let the compiler worry about the size? Or am I overlooking something 
obvious?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

