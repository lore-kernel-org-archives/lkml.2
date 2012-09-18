Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2IRFF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:05:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34721 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752267Ab2IRFFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:05:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Ju74rhPsJKwWlezalDs0jJSsGz139EqG9npBW8s
	toaKMpDrlW5ZLQ
Message-ID: <1347944751.7002.30.camel@marge.simpson.net>
Subject: Re: 2 physical-cpu (like 2x6core) config and NUMA?
From: Mike Galbraith <efault@gmx.de>
To: Linda Walsh <lkml@tlinx.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 18 Sep 2012 07:05:51 +0200
In-Reply-To: <5057654A.803@tlinx.org>
References: <5057654A.803@tlinx.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 11:00 -0700, Linda Walsh wrote: 
> I was wondering, on dual processor MB's, Intel uses dedicated memory for
> 
> each cpu ....  6 memchips in the X5XXX series, and to access the memory
> of the other chip's cores, the memory has to be transferred over the QPI
> bus.
> 
> So wouldn't it be of benefit if such dual chip configurations were to
> be setup as 'NUMA', as there is a higher cost between migrating 
> memory/processes
> between Cores on different chips vs. on the same chip?  
> 
> I note from 'cpupower -c all frequency-info, that the "odd" cpu-cores
> all hve to run at the same clock frequency, and the "even" all have
> to run together, which I take to mean that the odd number cores are
> on 1 chip and the even numbered cores are on the other chip.
> 
> Since the QPI path is limited and appears to be < the local memory access
> rate, wouldn't it be appropriate if 2 cpu-chip setups were configured
> as 2 NUMA cores?  
> 
> Although -- I have no clue how the memory space is divided between the
> two cores -- i.e. I don't know if say, I have 24G on each, if they
> alternate 4G in the physical address space or what (that would all be
> handed (or mapped) before the chips come up.. so it could be contiguous).
> 
> 
> Does the kernel support scheduling based on the different speed of
> memory between "on die" vs. "off die"?   I was surprised to see
> that it viewed my system as 1 NUMA node with all 12 on 1 node -- when
> I know that it is physically organized as 2x6.

Yeah, the scheduler will setup for numa if srat says the box is numa.

I have a 64 core DL980 box that numactl --hardware says is a single
node, but that's due to ram truly _existing_ only on one node.   Not a
wonderful (or even supported) setup.

If ram isn't physically plugged into the right spots, or some bios
option makes the box appear to be single node, that's what you'll see
too, (SIBLING maybe) MC and CPU domains, but no NUMA.

-Mike

