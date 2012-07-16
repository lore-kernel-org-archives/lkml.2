Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2GPJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:58:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2GPJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:58:22 -0400
Date: Mon, 16 Jul 2012 02:58:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shuah Khan <shuah.khan@hp.com>
cc: Pekka Enberg <penberg@kernel.org>, cl@linux.com, glommer@parallels.com,
        js1304@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <1342407840.3190.5.camel@lorien2>
Message-ID: <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2012, Shuah Khan wrote:

> I can work on reshuffling the code. Do have a question though. This
> following sanity check is currently done only when CONFIG_DEBUG_VM is
> defined. However, it does appear to be something that is that should be
> checked even in regular path.
> 
> struct kmem_cache *kmem_cache_create(const char *name, size_t size,
> size_t align,
>                 unsigned long flags, void (*ctor)(void *))
> {
>         struct kmem_cache *s = NULL;
> 
> #ifdef CONFIG_DEBUG_VM
>         if (!name || in_interrupt() || size < sizeof(void *) ||
>                 size > KMALLOC_MAX_SIZE) {
>                 printk(KERN_ERR "kmem_cache_create(%s) integrity check"
>                         " failed\n", name);
>                 goto out;
>         }
> #endif
> 

Agreed, this shouldn't depend on CONFIG_DEBUG_VM.
