Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1KQFGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:06:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59574 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KQFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:06:39 -0500
Date: Wed, 16 Nov 2011 21:06:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Claudio Scordino <claudio@evidence.eu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] /fs/proc/meminfo.c: fix compilation error
In-Reply-To: <4EB2C0DF.9050301@evidence.eu.com>
Message-ID: <alpine.DEB.2.00.1111162105400.13603@chino.kir.corp.google.com>
References: <4EB2C0DF.9050301@evidence.eu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011, Claudio Scordino wrote:

> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 5861741..80e4645 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -131,12 +131,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		K(i.freeswap),
>  		K(global_page_state(NR_FILE_DIRTY)),
>  		K(global_page_state(NR_WRITEBACK)),
> -		K(global_page_state(NR_ANON_PAGES)
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +		K(global_page_state(NR_ANON_PAGES)
>  		  + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
> -		  HPAGE_PMD_NR
> +		  HPAGE_PMD_NR),
> +#else
> +		K(global_page_state(NR_ANON_PAGES)),
>  #endif
> -		  ),
>  		K(global_page_state(NR_FILE_MAPPED)),
>  		K(global_page_state(NR_SHMEM)),
>  		K(global_page_state(NR_SLAB_RECLAIMABLE) +

Looks like this needs to be fixed for the per-node sysfs meminfo files as 
well?  See node_read_meminfo() in drivers/base/node.c.
