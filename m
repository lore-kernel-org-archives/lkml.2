Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2JVWIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:08:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2JVWIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:08:19 -0400
Date: Mon, 22 Oct 2012 15:08:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        levinsasha928@gmail.com, Marc.Zyngier@arm.com,
        virtualization@lists.linux-foundation.org, ericvh@gmail.com
Subject: Re: [PATCH v2 1/3] mm: highmem: export kmap_to_page for modules
Message-Id: <20121022150818.0e64da3a.akpm@linux-foundation.org>
In-Reply-To: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
References: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 14:03:31 +0100
Will Deacon <will.deacon@arm.com> wrote:

> Some virtio device drivers (9p) need to translate high virtual addresses
> to physical addresses, which are inserted into the virtqueue for
> processing by userspace.
> 
> This patch exports the kmap_to_page symbol, so that the affected drivers
> can be compiled as modules.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  mm/highmem.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index d517cd1..2a07f97 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -105,6 +105,7 @@ struct page *kmap_to_page(void *vaddr)
>  
>  	return virt_to_page(addr);
>  }
> +EXPORT_SYMBOL(kmap_to_page);
>  

Looks OK to me.  Would generally prefer that an exported-to-modules
symbol have some documentation, but I guess this one is obvious enough.

Rusty, please include this if you grab the rest of the series.

