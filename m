Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0LHPD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:03:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab0LHPDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:03:24 -0500
Date: Wed, 8 Dec 2010 10:02:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101208150243.GC31703@redhat.com>
References: <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
 <20101202161502.GL18100@redhat.com>
 <1291764620.2032.1293.camel@laptop>
 <20101208140103.GM21786@redhat.com>
 <1291818005.28378.38.camel@laptop>
 <20101208144245.GB31703@redhat.com>
 <1291819684.28378.70.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291819684.28378.70.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:48:04PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-08 at 09:42 -0500, Vivek Goyal wrote:
> > 
> > Either driver itself can detect that device is in inconsistent state and
> > reset it otherwise we also pass a command line parameter "reset_devices" to
> > second kernel to explicitly tell kernel that devices might be in bad state,
> > reset these during initialization. If we want to use these perf counters in
> > kdump kernel, we shall have to do something similar.
> 
> Right, so I'm perfectly fine with leaving the kdump kernel broken for
> now and if people really do need hardware events we can try and reset
> the hardware when we find that reset_devices command line parameter.
> 
> Not sure how that interacts with these broken BIOSes,

reset_devices was meant to be dual purpose so that it can handle broken
BIOSes also. So if BIOS is broken then one can pass "reset_devices" to 
kernel and driver can attempt to reset the device and boot the kernel.

>but its kdump so
> its mostly broken by design anyway ;-)

Kdump has its share of problems especially with the fact that
kernel/drivers find devices in bad state and are not hardened enough
to deal with that. But on bare metal what's the better way of capturing
kernel crash dump? Trying to do anything post crash in the kernel is
also not very reliable either.

I think the way we fix kernel for boot problems on newer hardware, for broken
BIOses, we need to keep on fixing it in kdump path also to make sure new
devices/drivers can cope up with this scenario. 

Thanks
Vivek 
