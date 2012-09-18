Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2IRPUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:20:19 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:15421 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834Ab2IRPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:20:13 -0400
Date: Tue, 18 Sep 2012 15:20:11 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 03/16] slab: Ignore the cflgs bit in cache creation
In-Reply-To: <1347977530-29755-4-git-send-email-glommer@parallels.com>
Message-ID: <00000139d9f7127d-c812558e-aa71-44b4-9629-d33cadba9929-000000@email.amazonses.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-4-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Glauber Costa wrote:

> No cache should ever pass that as a creation flag, since this bit is
> used to mark an internal decision of the slab about object placement. We
> can just ignore this bit if it happens to be passed (such as when
> duplicating a cache in the kmem memcg patches)

If we do this then I would like to see a general masking of internal
allocator bits in kmem_cache_create. We could declare the highest byte to
be the internal slab flags. SLUB uses two flags in that area. SLAB uses
one.

F.e. add

#define SLAB_INTERNAL 0xFF00000000UL

to slab.h.

Then the flags can then be masked in mm/slab_common.c

