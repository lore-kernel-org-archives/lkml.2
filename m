Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1EJOry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:47:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab1EJOrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:47:52 -0400
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nfont@austin.ibm.com
In-Reply-To: <4DC85BFE.7060900@linux.vnet.ibm.com>
References: <1299639487.22236.256.camel@pasglop>
	 <1299665998.2308.2753.camel@twins>  <1299675674.2308.2924.camel@twins>
	 <1299766211.2308.4468.camel@twins>  <1303294056.8345.122.camel@twins>
	 <1303336869.2513.26.camel@pasglop>  <4DC85BFE.7060900@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:09:23 +0200
Message-ID: <1305036563.2914.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 16:26 -0500, Jesse Larrew wrote:
> 
> According the the Power firmware folks, updating the home node of a
> virtual cpu happens rather infrequently. The VPHN code currently
> checks for topology updates every 60 seconds, but we can poll less
> frequently if it helps. I chose 60 second intervals simply because
> that's how often they check the topology on s390. ;-)

This just makes me shudder, so you poll the state? Meaning that the vcpu
can actually run 99% of the time on another node?

What's the point of this if the vcpu scheduler can move the vcpu around
much faster?

> As for updating the memory topology, there are cases where changing
> the home node of a virtual cpu doesn't affect the memory topology. If
> it does, there is a separate notification system for memory topology
> updates that is independent from the cpu updates. I plan to start
> working on a patch set to enable memory topology updates in the kernel
> in the coming weeks, but I wanted to get the cpu patches out on the
> list so we could start having these debates. :) 

Well, they weren't put out on a list (well maybe on the ppc list but
that's the same as not posting them from my pov), they were merged (and
thus declared done) that's not how you normally start a debate.

I would really like to see both patch-sets together. Also, I'm not at
all convinced its a sane thing to do. Pretty much all NUMA aware
software I know of assumes that CPU<->NODE relations are static,
breaking that in kernel renders all existing software broken.

