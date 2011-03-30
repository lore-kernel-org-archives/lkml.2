Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1C3CJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:09:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1C3CJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:09:49 -0400
Date: Tue, 29 Mar 2011 19:10:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: add alignment for some variables
Message-Id: <20110329191007.04e8376a.akpm@linux-foundation.org>
In-Reply-To: <1301450041.3981.55.camel@sli10-conroe>
References: <1301277536.3981.27.camel@sli10-conroe>
	<m2oc4v18x8.fsf@firstfloor.org>
	<1301360054.3981.31.camel@sli10-conroe>
	<20110329152434.d662706f.akpm@linux-foundation.org>
	<1301446882.3981.33.camel@sli10-conroe>
	<20110329180611.a71fe829.akpm@linux-foundation.org>
	<1301447843.3981.48.camel@sli10-conroe>
	<20110329182544.6ad4eccb.akpm@linux-foundation.org>
	<1301449000.3981.52.camel@sli10-conroe>
	<20110329184110.0086924e.akpm@linux-foundation.org>
	<1301450041.3981.55.camel@sli10-conroe>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 09:54:01 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> On Wed, 2011-03-30 at 09:41 +0800, Andrew Morton wrote:
> > On Wed, 30 Mar 2011 09:36:40 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> > 
> > > > how is it that this improves things?
> > > Hmm, it actually is:
> > > struct percpu_counter {
> > >  	spinlock_t lock;
> > >  	s64 count;
> > >  #ifdef CONFIG_HOTPLUG_CPU
> > >  	struct list_head list;	/* All percpu_counters are on a list */
> > >  #endif
> > >  	s32 __percpu *counters;
> > >  } __attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))
> > > so lock and count are in one cache line.
> > 
> > ____cacheline_aligned_in_smp would achieve that?
> ____cacheline_aligned_in_smp can't guarantee the cache alignment for
> multiple nodes, because the variable can be updated by multiple
> nodes/cpus.

Confused.  If an object is aligned at a mulitple-of-128 address on one
node, it is aligned at a multiple-of-128 address when viewed from other
nodes, surely?

Even if the cache alignment to which you're referring is the internode
cache, can a 34-byte, L1-cache-aligned structure ever span multiple
internode cachelines?


