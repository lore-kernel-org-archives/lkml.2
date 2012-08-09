Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030446Ab2HIOUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:20:53 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34856 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188Ab2HIOUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:20:50 -0400
Date: Thu, 9 Aug 2012 09:13:06 -0500 (CDT)
From: "Christoph Lameter (Open Source)" <cl@linux.com>
X-X-Sender: cl@greybox.home
To: Shuah Khan <shuah.khan@hp.com>
cc: penberg@kernel.org, glommer@parallels.com, js1304@gmail.com,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, shuahkhan@gmail.com
Subject: Re: [PATCH v2] mm: Restructure kmem_cache_create() to move debug
 cache integrity checks into a new function
In-Reply-To: <1344287631.2486.57.camel@lorien2>
Message-ID: <alpine.DEB.2.02.1208090911100.15909@greybox.home>
References: <1342221125.17464.8.camel@lorien2> <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com> <1344224494.3053.5.camel@lorien2> <1344266096.2486.17.camel@lorien2> <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
 <1344272614.2486.40.camel@lorien2> <1344287631.2486.57.camel@lorien2>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Shuah Khan wrote:

> +#ifdef CONFIG_DEBUG_VM
> +static int kmem_cache_sanity_check(const char *name, size_t size)

Why do we pass "size" in? AFAICT there is no need to.

> @@ -53,48 +93,17 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
>  {
>  	struct kmem_cache *s = NULL;
>
> -#ifdef CONFIG_DEBUG_VM
>  	if (!name || in_interrupt() || size < sizeof(void *) ||
>  		size > KMALLOC_MAX_SIZE) {
> -		printk(KERN_ERR "kmem_cache_create(%s) integrity check"
> -			" failed\n", name);
> +		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
>  		goto out;
>  	}
> -#endif
>

If you move the above code into the sanity check function then you will be
using the size as well. These are also sanity checks after all.
