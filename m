Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2FFJP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:15:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:60008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2FFJP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:15:58 -0400
Message-ID: <1338974105.2749.85.camel@twins>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched
 domain support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <lkml.alex@gmail.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com, Alex Shi <alex.shi@intel.com>,
        linux-tip-commits@vger.kernel.org
Date: Wed, 06 Jun 2012 11:15:05 +0200
In-Reply-To: <CAGjg+kFhGwhjfxp3vmQbDVUyHiOfn1HMKBDgtjZKU_f+fw=JWw@mail.gmail.com>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	 <CAGjg+kFhGwhjfxp3vmQbDVUyHiOfn1HMKBDgtjZKU_f+fw=JWw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 15:43 +0800, Alex Shi wrote:
> > +       /*
> > +        * O(nr_nodes^2) deduplicating selection sort -- in order to find the
> > +        * unique distances in the node_distance() table.
> > +        *
> > +        * Assumes node_distance(0,j) includes all distances in
> > +        * node_distance(i,j) in order to avoid cubic time.
> 
> Curious for other platforms node_distance number, actually, this
> assumption is right for what I saw Intel platforms. but it is not
> match acpispec50.pdf:
> 
> Table 6-152 Example Relative Distances Between Proximity Domains
> Proximity Domain 0 1 2 3
> 0 10 15 20 18
> 1 15 10 16 24
> 2 20 16 10 12
> 3 18 24 12 10

Yes I know its allowed, I just haven't seen it in practice.

I've got a patch that validates this assumption if you boot with
"sched_debug". If we ever run into such a setup we might need to fix
this -- it shouldn't be too hard, just expensive.
