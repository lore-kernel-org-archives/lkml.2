Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1GTOlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:41:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46353 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1GTOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:41:08 -0400
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>
In-Reply-To: <4E26E705.8050704@parallels.com>
References: <20110720121612.28888.38970.stgit@localhost6>
	 <alpine.DEB.2.00.1107201611010.3528@tiger> <4E26D7EA.3000902@parallels.com>
	 <alpine.DEB.2.00.1107201638520.4921@tiger>
	 <alpine.DEB.2.00.1107200852590.32737@router.home>
	 <20110720142018.GL5349@suse.de>  <4E26E705.8050704@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 16:40:59 +0200
Message-ID: <1311172859.2338.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 juillet 2011 à 18:32 +0400, Konstantin Khlebnikov a
écrit :

> I catch this on our rhel6-openvz kernel, and yes it very patchy,
> but I don't see any reasons why this cannot be reproduced on mainline kernel.
> 
> there was abount ten containers with random stuff, node already do intensive swapout but still alive,
> in this situation starting new containers sometimes (1 per 1000) fails due to kmem_cache_create failures in nf_conntrack,
> there no other messages except:
> Unable to create nf_conn slab cache
> and some
> nf_conntrack: falling back to vmalloc.
> (it try allocates huge hash table and do it via vmalloc if kmalloc fails)


Does this kernel contain commit 6d4831c2 ?
(vfs: avoid large kmalloc()s for the fdtable)



