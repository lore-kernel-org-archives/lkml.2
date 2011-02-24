Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1BXJdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:33:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab1BXJdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:33:07 -0500
Date: Thu, 24 Feb 2011 10:33:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM
Message-ID: <20110224093304.GA20922@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
 <1298485162.7236.4.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298485162.7236.4.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-02-11 10:19:22, Dave Hansen wrote:
> On Wed, 2011-02-23 at 16:10 +0100, Michal Hocko wrote:
> > We can reduce this internal fragmentation by splitting the single
> > page_cgroup array into more arrays where each one is well kmalloc
> > aligned. This patch implements this idea. 
> 
> How about using alloc_pages_exact()?  These things aren't allocated
> often enough to really get most of the benefits of being in a slab.

Yes, you are right. alloc_pages_exact (which I wasn't aware of) is much
simpler solution and it gets comparable results. I will prepare the
patch for review.

Thanks for pointing this out.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
