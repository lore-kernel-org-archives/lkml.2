Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1E2IQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:16:29 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54866 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2IQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:16:27 -0400
Date: Sun, 29 May 2011 13:46:18 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: svaidy@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, thomas.abraham@linaro.org
Subject: Re: [PATCH 01/10] mm: Introduce the memory regions data structure
Message-ID: <20110529081618.GC8333@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <1306499498-14263-2-git-send-email-ankita@in.ibm.com>
 <1306510203.22505.69.camel@nimitz>
 <20110527182041.GM5654@dirshya.in.ibm.com>
 <1306531912.22505.84.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306531912.22505.84.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, May 27, 2011 at 02:31:52PM -0700, Dave Hansen wrote:
> On Fri, 2011-05-27 at 23:50 +0530, Vaidyanathan Srinivasan wrote:
> > The overall idea is to have a VM data structure that can capture
> > various boundaries of memory, and enable the allocations and reclaim
> > logic to target certain areas based on the boundaries and properties
> > required. 
> 
> It's worth noting that we already do targeted reclaim on boundaries
> other than zones.  The lumpy reclaim and memory compaction logically do
> the same thing.  So, it's at least possible to do this without having
> the global LRU designed around the way you want to reclaim.
>

My understanding maybe incorrect, but doesn't both lumpy reclaim and
memory compaction still work under zone boundary ? While trying to free
up higher order pages, lumpy reclaim checks to ensure that pages that
are selected do not cross zone boundary. Further, compaction walks
through the pages in a zone and tries to re-arrange them.
 
> Also, if you get _too_ dependent on the global LRU, what are you going
> to do if our cgroup buddies manage to get cgroup'd pages off the global
> LRU?  
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
