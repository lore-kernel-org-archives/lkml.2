Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487Ab2HWK6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:58:30 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34740 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030301Ab2HWK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:58:25 -0400
Date: Thu, 23 Aug 2012 12:58:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "3.2.x.." <stable@kernel.org>
Subject: Re: [PATCH 01/10] alpha: Add missing RCU idle APIs on idle loop
Message-ID: <20120823105816.GB18835@somewhere.redhat.com>
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
 <1345652628-15060-2-git-send-email-fweisbec@gmail.com>
 <5035F8A2.1070702@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5035F8A2.1070702@orcon.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 09:32:18PM +1200, Michael Cree wrote:
> On 23/08/12 04:23, Frederic Weisbecker wrote:
> > In the old times, the whole idle task was considered
> > as an RCU quiescent state. But as RCU became more and
> > more successful overtime, some RCU read side critical
> > section have been added even in the code of some
> > architectures idle tasks, for tracing for example.
> 
> Fantastic!  It fixes RCU CPU stalls that we were seeing on the SMP
> kernel when built for generic Alpha.
> 
> A build of glibc and running its test suite reliably triggers RCU CPU
> stalls when running a kernel built for generic Alpha.  I have just built
> glibc and ran its test suite twice with no RCU CPU stalls with this
> patch against a 3.5.2 kernel!  Nice.  Very nice.
> 
> I see the stable queue is CCed but I note the patch does not apply
> cleanly to the 3.2.y kernel.  It would be nice to have a backport of the
> patches for the 3.2 stable kernel.

Sure.

> 
> So feel free to add:
> 
> Tested-by:  Michael Cree <mcree@orcon.net.nz>

Thanks, but I need to refactor the patch, I suspect a problem with CONFIG_PREEMPT.
