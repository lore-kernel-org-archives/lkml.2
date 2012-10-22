Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2JVOlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:41:39 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:45532 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab2JVOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:41:38 -0400
Date: Mon, 22 Oct 2012 14:41:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at
 /proc/meminfo
In-Reply-To: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com>
Message-ID: <0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com>
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Ezequiel Garcia wrote:

> On page allocations, SLAB and SLUB modify zone page state counters
> NR_SLAB_UNRECLAIMABLE or NR_SLAB_RECLAIMABLE.
> This allows to obtain slab usage information at /proc/meminfo.
>
> Without this patch, /proc/meminfo will show zero Slab usage for SLOB.
>
> Since SLOB discards SLAB_RECLAIM_ACCOUNT flag, we always use
> NR_SLAB_UNRECLAIMABLE zone state item.

Hmmm... that is unfortunate. The NR_SLAB_RECLAIMABLE stat is used by
reclaim to make decisions on when to reclaim inodes and dentries.

Could you fix that to properly account the reclaimable/unreclaimable
pages?
