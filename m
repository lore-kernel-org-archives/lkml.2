Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2FYXWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab2FYXV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:21:59 -0400
Date: Mon, 25 Jun 2012 16:21:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Pekka Enberg" <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
Message-Id: <20120625162158.cde295bf.akpm@linux-foundation.org>
In-Reply-To: <4FE8E7EB.2020804@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-10-git-send-email-glommer@parallels.com>
	<20120625182907.GF3869@google.com>
	<4FE8E7EB.2020804@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012 02:36:27 +0400
Glauber Costa <glommer@parallels.com> wrote:

> On 06/25/2012 10:29 PM, Tejun Heo wrote:
> > Feeling like a nit pervert but..
> >
> > On Mon, Jun 25, 2012 at 06:15:26PM +0400, Glauber Costa wrote:
> >> @@ -287,7 +287,11 @@ struct mem_cgroup {
> >>   	 * Should the accounting and control be hierarchical, per subtree?
> >>   	 */
> >>   	bool use_hierarchy;
> >> -	bool kmem_accounted;
> >> +	/*
> >> +	 * bit0: accounted by this cgroup
> >> +	 * bit1: accounted by a parent.
> >> +	 */
> >> +	volatile unsigned long kmem_accounted;
> >
> > Is the volatile declaration really necessary?  Why is it necessary?
> > Why no comment explaining it?
> 
> Seems to be required by set_bit and friends. gcc will complain if it is 
> not volatile (take a look at the bit function headers)

That would be a broken gcc.  We run test_bit()/set_bit() and friends
against plain old `unsigned long' in thousands of places.  There's
nothing special about this one!


