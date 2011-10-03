Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1JCVH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:07:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:57464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1JCVHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:07:22 -0400
Subject: Re: lockdep recursive locking detected (rcu_kthread / __cache_free)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org
Date: Mon, 03 Oct 2011 23:06:19 +0200
In-Reply-To: <alpine.DEB.2.00.1110031540560.11713@router.home>
References: <20111003175322.GA26122@sucs.org>
	 <20111003203139.GH2403@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1110031540560.11713@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317675980.9417.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 15:46 -0500, Christoph Lameter wrote:
> On Mon, 3 Oct 2011, Paul E. McKenney wrote:
> 
> > The first lock was acquired here in an RCU callback.  The later lock that
> > lockdep complained about appears to have been acquired from a recursive
> > call to __cache_free(), with no help from RCU.  This looks to me like
> > one of the issues that arise from the slab allocator using itself to
> > allocate slab metadata.
> 
> Right. However, this is a false positive since the slab cache with
> the metadata is different from the slab caches with the slab data. The slab
> cache with the metadata does not use itself any metadata slab caches.

Sure, but we're supposed to have annotated that.. see
init_node_lock_keys()
