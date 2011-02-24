Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1BXKJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:09:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42495 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1BXKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:09:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Feb 2011 19:02:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM
Message-Id: <20110224190247.bdc2e6f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110224093519.GB20922@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
	<1298485162.7236.4.camel@nimitz>
	<20110224085227.1a3e185b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110224093519.GB20922@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 10:35:19 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 24-02-11 08:52:27, KAMEZAWA Hiroyuki wrote:
> > On Wed, 23 Feb 2011 10:19:22 -0800
> > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > 
> > > On Wed, 2011-02-23 at 16:10 +0100, Michal Hocko wrote:
> > > > We can reduce this internal fragmentation by splitting the single
> > > > page_cgroup array into more arrays where each one is well kmalloc
> > > > aligned. This patch implements this idea. 
> > > 
> > > How about using alloc_pages_exact()?  These things aren't allocated
> > > often enough to really get most of the benefits of being in a slab.
> > > That'll at least get you down to a maximum of about PAGE_SIZE wasted.  
> > > 
> > 
> > yes, alloc_pages_exact() is much better.
> > 
> > packing page_cgroups for multiple sections causes breakage in memory hotplug logic.
> 
> I am not sure I understand this. What do you mean by packing
> page_cgroups for multiple sections? The patch I have posted doesn't do
> any packing. Or do you mean that using a double array can break hotplog?
> Not that this would change anything, alloc_pages_exact is really a
> better solution, I am just curious ;) 
> 

Sorry, it seems I failed to read code correctly. 
You just implemented 2 level table..


Thanks,
-Kame


