Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2CVDI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:08:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46737 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2CVDI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:08:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rjw@sisk.pl, tglx@linutronix.de
Cc: xen-devel@lists.xensource.com
Subject: Re: Regression in v3.4-rc0 " BUG: soft lockup - CPU#0 stuck for 29s! [migration/0:6]..[<ffffffff810d3b8b>] stop_machine_cpu_stop+0x7b/0xf
Date: Wed, 21 Mar 2012 23:04:08 -0400
Message-Id: <1332385449-29281-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1332347541.18960.498.camel@twins>
References: <1332347541.18960.498.camel@twins>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F6A97AF.003B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 05:32:21PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-03-21 at 17:30 +0100, Peter Zijlstra wrote:
> > On Wed, 2012-03-21 at 16:57 +0100, Peter Zijlstra wrote:
> > > On Wed, 2012-03-21 at 11:26 -0400, Konrad Rzeszutek Wilk wrote:
> > > > On Tue, Mar 20, 2012 at 07:53:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > > Seeing this in v3.4-rc0 tree and didn't see that with v3.3:
> > > > 
> > > > Hey Peter,
> > > > 
> > > > Git bisection points this to the fault of
> > > > 5fbd036b552f633abb394a319f7c62a5c86a9cd7 " sched: Cleanup cpu_active madness"
> > > > 
> > > > thoughts? (also attaching the .config) 
> > > 
> > > Argh.. so when is this? boot? No that's somewhat unexpected. I have one
> > > report of funnies during a hotplug bash that I'm looking into, but I
> > > haven't actually been able to reproduce that report myself either.
> > 
> > is arch/x86/xen/smp.c:cpu_bringup() missing a call to
> > notify_cpu_starting() before doing set_cpu_online()?
> > 
> > Also, shouldn't that also take the ipi_call_lock() around setting the
> > cpu online?
> 
> 
> And before you ask, yes all that should live in generic code... somehow.
> This per-arch replication of the cpu hotplug logic is driving me insane.

Thanks to Peter,  here is the patch that fixes the regression.
