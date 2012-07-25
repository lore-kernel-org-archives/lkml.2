Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2GYT7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:59:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2GYT7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:59:52 -0400
Date: Wed, 25 Jul 2012 12:59:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/34] mm: vmscan: Do not force kswapd to scan small
 targets
Message-ID: <20120725195948.GB5444@kroah.com>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343050727-3045-31-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343050727-3045-31-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 02:38:43PM +0100, Mel Gorman wrote:
> commit ad2b8e601099a23dffffb53f91c18d874fe98854 upstream - WARNING: this is a substitute patch.
> 
> Stable note: Not tracked in Bugzilla. This is a substitute for an
> 	upstream commit addressing a completely different issue that
> 	accidentally contained an important fix. The workload this patch
> 	helps was memcached when IO is started in the background. memcached
> 	should stay resident but without this patch it gets swapped more
> 	than it should. Sometimes this manifests as a drop in throughput
> 	but mostly it was observed through /proc/vmstat.
> 
> Commit [246e87a9: memcg: fix get_scan_count() for small targets] was
> meant to fix a problem whereby small scan targets on memcg were ignored
> causing priority to raise too sharply. It forced scanning to take place
> if the target was small, memcg or kswapd.
> 
> >From the time it was introduced it cause excessive reclaim by kswapd
> with workloads being pushed to swap that previously would have stayed
> resident. This was accidentally fixed by commit [ad2b8e60: mm: memcg:
> remove optimization of keeping the root_mem_cgroup LRU lists empty] but
> that patchset is not suitable for backporting.
> 
> The original patch came with no information on what workloads it benefits
> but the cost of it is obvious in that it forces scanning to take place
> on lists that would otherwise have been ignored such as small anonymous
> inactive lists. This patch partially reverts 246e87a9 so that small lists
> are not force scanned which means that IO-intensive workloads with small
> amounts of anonymous memory will not be swapped.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |    3 ---
>  1 file changed, 3 deletions(-)

I don't understand this patch.  The original
ad2b8e601099a23dffffb53f91c18d874fe98854 commit touched the file
mm/memcontrol.c and seemed to do something quite different from what you
have done below.

I'm all for fixing things in a different way than what was done in
Linus's tree, IF there is a reason to, but the comparison between these
two patches (yours and upstream) are not making any sense at all.

confused,

greg k-h
