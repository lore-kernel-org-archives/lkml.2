Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806Ab2HXQPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:15:21 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:23890 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759760Ab2HXQPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:15:18 -0400
Date: Fri, 24 Aug 2012 16:15:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] slub: correct the calculation of the number of cpu
 objects in get_partial_node
In-Reply-To: <1345824303-30292-2-git-send-email-js1304@gmail.com>
Message-ID: <00000139596a800b-875d7863-23ac-44a5-8710-ea357f3df8a8-000000@email.amazonses.com>
References: <Yes> <1345824303-30292-1-git-send-email-js1304@gmail.com> <1345824303-30292-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012, Joonsoo Kim wrote:

> index d597530..c96e0e4 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1538,6 +1538,7 @@ static void *get_partial_node(struct kmem_cache *s,
>  {
>  	struct page *page, *page2;
>  	void *object = NULL;
> +	int cpu_slab_objects = 0, pobjects = 0;

We really need be clear here.

One counter is for the numbe of objects in the per cpu slab and the other
for the objects in tbhe per cpu partial lists.

So I think the first name is ok. Second should be similar

cpu_partial_objects?


