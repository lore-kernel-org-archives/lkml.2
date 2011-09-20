Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab1ITOTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:19:06 -0400
Received: from broadrack.ru ([195.178.208.66]:57739 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750765Ab1ITOTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:19:05 -0400
Date: Tue, 20 Sep 2011 18:18:56 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: POHMELFS is back
Message-ID: <20110920141856.GA14739@ioremap.net>
References: <20110919061302.GA19699@ioremap.net>
 <9891.1316455851@turing-police.cc.vt.edu>
 <20110920055812.GA7910@ioremap.net>
 <29686.1316526117@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29686.1316526117@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 09:41:57AM -0400, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > If you get 10 times more bandwidth you will not be able to saturate it
> > with 10 times less servers.
> 
> The point is that the solutions we're looking at are able to drive enough I/O
> *per server* that we need to look at 10GigE and Infiniband connections. Your
> numbers currently indicate about 5T of disk and 75 megabit of throughput per
> node, while current solutions are doing about 100T and pushing a 10GigE per
> node.  So you have a *lot* of per-server scaling work to do still...

Number of server nodes is smaller, and number of physical servers may be
even less. There is a fair number of proxy servers for cluster.

But overall of course every server does not saturate own 1gige link,
since, well, our uplinks are just gigabits :)

> >                                              Scaling to hundreds of server nodes is a
> > good result, since we evenly balance all IO between nodes and no single
> > server is disk or network bound.
> 
> You missed the point. Scaling to hundreds of server nodes is a nice
> *theoretical* result, but one that's not going to get a lot of traction out in
> the real world, where the *per server* scaling matters too.  Which is my boss
> more likely to be willing to spend money on - a solution that has 50 servers
> per datacenter to deliver 4 Gb/sec per data center, or one that is delivering
> that much *per server*? Remember - servers cost money, rack space costs money,

You are not able to setup 1 server and deliver 4Gb/sec of random IO.
If you think this is possible, than you actualyl did not try to do it
with existing solutions.

> Looked at differently - if I'm currently targeting multiple gigabytes/sec throughput
> to a petabyte of disk from a half-dozen servers, how big and fast a disk farm
> could I build if I had 50 servers in the room, or 200 across datacenters?

A simple question, what RPS rate you got for random reads and writes?

Your solution may scale to bandwifth limits, which is not interesting
for us. Huge single-or-small-node solution is random IO limited, but if
you read big file, then you will be network limited, and can show nice
numbers of Gb/ solution is random IO limited, but if you read big file,
then you will be network limited, and can show nice numbers of Gb/s.

As of GPFS you mentioned, then you did not try to setup cluster with
weak links (i.e. between physically different datacenters), since it
resynchronizes nodes on every glitch and does not scale to RPS, although
quite good ad bulk IO.

So, basically, Elliptics was created for low-latency RPS loads and not
BULK IO.

-- 
	Evgeniy Polyakov
