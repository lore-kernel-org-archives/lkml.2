Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1CINyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:54:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab1CINyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:54:52 -0500
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
In-Reply-To: <20110309144636.3f0899d1@mschwide.boeblingen.de.ibm.com>
References: <1299639487.22236.256.camel@pasglop>
	 <1299665998.2308.2753.camel@twins> <1299670429.2308.2834.camel@twins>
	 <20110309141548.722e4f56@mschwide.boeblingen.de.ibm.com>
	 <1299676769.2308.2944.camel@twins>
	 <20110309143152.3cc6c191@mschwide.boeblingen.de.ibm.com>
	 <1299677636.2308.2960.camel@twins>
	 <20110309144636.3f0899d1@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 14:54:39 +0100
Message-ID: <1299678879.2308.2987.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 14:46 +0100, Martin Schwidefsky wrote:
> On Wed, 09 Mar 2011 14:33:56 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2011-03-09 at 14:31 +0100, Martin Schwidefsky wrote:
> > > > But if you don't also update the cpu->node memory mappings (which I
> > > > think it near impossible) what good is it to change the scheduler
> > > > topology?
> > > 
> > > The memory for the different LPARs is striped over all nodes (or books as we
> > > call them). We heavily rely on the large shared cache between the books to hide
> > > the different memory access latencies. 
> > 
> > Right, so effectively you don't have NUMA due to that striping. So why
> > then change the CPU topology? Simply create a topology without NUMA and
> > keep it static, that accurately reflects the memory topology.
> 
> Well the CPU topology can change due to different grouping of logical CPUs
> dependent on which LPARs are activated. And we effectively do not have a
> memory topology, only CPU. Its basically all about caches, we want to
> reflect the distance between CPUs over the up to 4 cache levels.

Right, so I consider caches to be part of the memory topology, anyway,
if this all is very rare then yeah, that works out.
