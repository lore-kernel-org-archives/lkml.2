Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab2CUSF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:05:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52580 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2CUSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:05:23 -0400
Subject: Re: Patch workqueue: create new slab cache instead of hacking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1203211253520.21932@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
	 <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com>
	 <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com>
	 <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
	 <alpine.DEB.2.00.1203210910450.20482@router.home>
	 <1332341381.7893.17.camel@edumazet-glaptop>
	 <alpine.DEB.2.00.1203210959500.21932@router.home>
	 <1332345859.5330.8.camel@edumazet-glaptop>
	 <alpine.DEB.2.00.1203211253520.21932@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 11:05:19 -0700
Message-ID: <1332353119.9433.2.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 12:54 -0500, Christoph Lameter wrote:
> On Wed, 21 Mar 2012, Eric Dumazet wrote:
> 
> > On Wed, 2012-03-21 at 10:03 -0500, Christoph Lameter wrote:
> > > On Wed, 21 Mar 2012, Eric Dumazet wrote:
> > >
> > > > Creating a dedicated cache for few objects ? Thats a lot of overhead, at
> > > > least for SLAB (no merges of caches)
> > >
> > > Its some overhead for SLAB (a lot is what? If you tune down the per cpu
> > > caches it should be a couple of pages) but its none for SLUB.
> >
> > SLAB overhead per cache is O(CPUS * nr_node_ids)  (unless alien caches
> > are disabled)
> 
> nr_node_ids==2 in the standard case these days. Alien caches are minimal.


Thats not true. Some machines use lots of nodes (fake nodes) for various
reasons.

And they cant disable alien caches for performance reasons.



