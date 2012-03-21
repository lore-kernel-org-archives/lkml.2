Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab2CUQch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:32:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:53656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759701Ab2CUQcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:32:36 -0400
Message-ID: <1332347541.18960.498.camel@twins>
Subject: Re: Regression in v3.4-rc0 " BUG: soft lockup - CPU#0 stuck for
 29s! [migration/0:6]..[<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf"
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        gregkh@linuxfoundation.org, rjw@sisk.pl
Date: Wed, 21 Mar 2012 17:32:21 +0100
In-Reply-To: <1332347432.18960.497.camel@twins>
References: <20120320235322.GA5416@phenom.dumpdata.com>
	 <20120321152649.GA32737@phenom.dumpdata.com>
	 <1332345420.18960.495.camel@twins> <1332347432.18960.497.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 17:30 +0100, Peter Zijlstra wrote:
> On Wed, 2012-03-21 at 16:57 +0100, Peter Zijlstra wrote:
> > On Wed, 2012-03-21 at 11:26 -0400, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Mar 20, 2012 at 07:53:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > Seeing this in v3.4-rc0 tree and didn't see that with v3.3:
> > > 
> > > Hey Peter,
> > > 
> > > Git bisection points this to the fault of
> > > 5fbd036b552f633abb394a319f7c62a5c86a9cd7 " sched: Cleanup cpu_active madness"
> > > 
> > > thoughts? (also attaching the .config) 
> > 
> > Argh.. so when is this? boot? No that's somewhat unexpected. I have one
> > report of funnies during a hotplug bash that I'm looking into, but I
> > haven't actually been able to reproduce that report myself either.
> 
> is arch/x86/xen/smp.c:cpu_bringup() missing a call to
> notify_cpu_starting() before doing set_cpu_online()?
> 
> Also, shouldn't that also take the ipi_call_lock() around setting the
> cpu online?


And before you ask, yes all that should live in generic code... somehow.
This per-arch replication of the cpu hotplug logic is driving me insane.
