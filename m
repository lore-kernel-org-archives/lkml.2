Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2JOUpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:45:55 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:14660 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab2JOUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:45:53 -0400
Date: Mon, 15 Oct 2012 20:44:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] SLUB: increase the range of slab sizes available to
 kmalloc, allowing a somewhat more effient use of memory.
In-Reply-To: <1350145885-6099-3-git-send-email-richard@rsk.demon.co.uk>
Message-ID: <0000013a662b9db5-1ea40fb2-3337-4cbc-8eca-5a610564dd75-000000@email.amazonses.com>
References: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk> <1350145885-6099-2-git-send-email-richard@rsk.demon.co.uk> <1350145885-6099-3-git-send-email-richard@rsk.demon.co.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2012, Richard Kennedy wrote:

> -extern struct kmem_cache *kmalloc_caches[SLUB_PAGE_SHIFT];
>
> -/*
> - * Sorry that the following has to be that ugly but some versions of GCC
> - * have trouble with constant propagation and loops.
> +static const short __slab_sizes[] = {0, 8, 12, 16, 24, 32, 48, 64, 96,
> +				     128, 192, 256, 384, 512, 768, 1024,
> +				     1536, 2048, 3072, 4096, 6144, 8192};
> +

Urg. No thanks. What is the exact benefit of this patch?
