Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1EPVKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:10:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42252 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab1EPVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PL4CdAF4WZpauAUO4r29zHVzSdPlbKErEzN6cuhxVQ37X67aHgs2X7aGnI8tgw7KJQ
         13iveN6aAH9OqsbJY3dg==
Date: Mon, 16 May 2011 14:10:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: slub: Do not wake kswapd for SLUBs speculative
 high-order allocations
In-Reply-To: <1305295404-12129-3-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1105161410090.4353@chino.kir.corp.google.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-3-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Mel Gorman wrote:

> To avoid locking and per-cpu overhead, SLUB optimisically uses
> high-order allocations and falls back to lower allocations if they
> fail.  However, by simply trying to allocate, kswapd is woken up to
> start reclaiming at that order. On a desktop system, two users report
> that the system is getting locked up with kswapd using large amounts
> of CPU.  Using SLAB instead of SLUB made this problem go away.
> 
> This patch prevents kswapd being woken up for high-order allocations.
> Testing indicated that with this patch applied, the system was much
> harder to hang and even when it did, it eventually recovered.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
