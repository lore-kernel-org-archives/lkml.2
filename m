Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2GNJS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 05:18:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2GNJS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 05:18:27 -0400
Date: Sat, 14 Jul 2012 02:18:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shuah Khan <shuah.khan@hp.com>
cc: cl@linux.com, penberg@kernel.org, glommer@parallels.com, js1304@gmail.com,
        shuahkhan@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <1342221125.17464.8.camel@lorien2>
Message-ID: <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com>
References: <1342221125.17464.8.camel@lorien2>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Shuah Khan wrote:

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 12637ce..aa3ca5b 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -98,7 +98,9 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
>  
>  	s = __kmem_cache_create(name, size, align, flags, ctor);
>  
> +#ifdef CONFIG_DEBUG_VM
>  oops:
> +#endif
>  	mutex_unlock(&slab_mutex);
>  	put_online_cpus();
>  

Tip: gcc allows label attributes so you could actually do

oops: __maybe_unused

to silence the warning and do the same for the "out" label later in the 
function.
