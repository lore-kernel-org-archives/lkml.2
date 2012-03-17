Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2CQVAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 17:00:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2CQVAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 17:00:48 -0400
Message-ID: <1332018034.18960.247.camel@twins>
Subject: Re: cpu_active vs pcrypt & padata
From: Peter Zijlstra <peterz@infradead.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 17 Mar 2012 22:00:34 +0100
In-Reply-To: <20120316104409.GP15404@secunet.com>
References: <1331892788.18960.227.camel@twins>
	 <20120316104409.GP15404@secunet.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 11:44 +0100, Steffen Klassert wrote:
> Hi.
> 
> On Fri, Mar 16, 2012 at 11:13:08AM +0100, Peter Zijlstra wrote:
> > Hi Steffen,
> > 
> > I found cpu_active usage in crypto/pcrypt.c and was wondering what
> > that's doing there. I would really like to contain that thing to as
> > narrow a piece of kernel as I possible can (sched/cpuset/hotplug) but it
> > appears to be spreading.
> 
> pcrypt uses cpu_active to tell padata which cpuset it whishes
> to use for parallelization. I could try to push the cpumask
> handling down to padata if you want to limit this to the core
> kernel.

/me more confused now.. cpu_active isn't in any way shape or form
related to cpusets.

> > Also, wth is all this kernel/padata.c stuff? There's next to no useful
> > comment in there and the only consumer seems to be pcrypt, does that
> > really need to be in kernel/ ?
> 
> The padata code is generic and not limited to crypto, you can find
> a documentation at Documentation/padata.txt.

Would be nice to have a short blurb in kernel/padata.c with a reference
to that Documentation stuff for more in-depth bits.
