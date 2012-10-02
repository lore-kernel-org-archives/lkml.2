Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2JBSL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:11:27 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:5318 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab2JBSL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:11:26 -0400
Date: Tue, 2 Oct 2012 18:11:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3] slab: Ignore internal flags in cache creation
In-Reply-To: <1349171968-19243-1-git-send-email-glommer@parallels.com>
Message-ID: <0000013a22acdcd4-ba2fbe44-ae66-4b10-86fa-d49d907d9dda-000000@email.amazonses.com>
References: <1349171968-19243-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Glauber Costa wrote:

>  #include <linux/kmemleak.h>
>
> +#define SLAB_AVAILABLE_FLAGS	0xFFFFFFFFUL /* No flag restriction */
> +
>  enum stat_item {

I thought the SLAB_AVAILABLE_FLAGS would stand for something meaningful
like the flags supported by an allocator given a kernel config. F.e. SLUB
does not support the debug flags if not compiled with debug.

This looks like it could become material that would fit in mm/slab.h.
There are sets of flags that all allocators have to support (RCU, DMA etc)
and others (like the debug flags) that are optional.

Slob also supports some flags but never any of the debug flags.

