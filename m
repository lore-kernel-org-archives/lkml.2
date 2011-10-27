Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1J0Iuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:50:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40860 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab1J0Iuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:50:39 -0400
Date: Thu, 27 Oct 2011 10:50:25 +0200
From: Mel Gorman <mel@csn.ul.ie>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] cache align vm_stat
Message-ID: <20111027085008.GA6563@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:10:35AM -0500, Dimitri Sivanich wrote:
> Avoid false sharing of the vm_stat array.
> 
> This was found to adversely affect tmpfs I/O performance.
> 

I think this fix is overly simplistic. It is moving each counter into
its own cache line. While I accept that this will help the preformance
of the tmpfs-based workload, it will adversely affect workloads that
touch a lot of counters because of the increased cache footprint.

1. Is it possible to rearrange the vmstat array such that two hot
   counters do not share a cache line?
2. Has Andrew's suggestion to alter the per-cpu threshold based on the
   value of the global counter to reduce conflicts been tried?

(I'm at Linux Con at the moment so will be even slower to respond than
usual)

-- 
Mel Gorman
SUSE Labs
