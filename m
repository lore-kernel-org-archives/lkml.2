Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0LHPXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:23:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0LHPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:23:02 -0500
Date: Wed, 8 Dec 2010 10:22:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101208152231.GD31703@redhat.com>
References: <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
 <20101202161502.GL18100@redhat.com>
 <1291764620.2032.1293.camel@laptop>
 <20101208140103.GM21786@redhat.com>
 <1291818005.28378.38.camel@laptop>
 <20101208144245.GB31703@redhat.com>
 <1291819684.28378.70.camel@laptop>
 <20101208150243.GC31703@redhat.com>
 <1291821307.28378.93.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291821307.28378.93.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 04:15:07PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-08 at 10:02 -0500, Vivek Goyal wrote:
> 
> > >but its kdump so its mostly broken by design anyway ;-)
> > 
> > Kdump has its share of problems especially with the fact that
> > kernel/drivers find devices in bad state and are not hardened enough
> > to deal with that. But on bare metal what's the better way of capturing
> > kernel crash dump? Trying to do anything post crash in the kernel is
> > also not very reliable either.
> 
> /me <3 RS-232
> 
> I haven't found anything better than that... 

Serial is good for getting the oops out. But for the big vmcore? Secondly,
people want the flexibility of sending the vmcore over various targets
like over network to some remote server. Booting into second kernel opens
up all those options and now one can do intelligent filtering and send
the vmcore to any kind of destination.

> 
> And poking at the RS-232 requires less of the kernel to be functional
> than booting into a new kernel (whose image might have been corrupted by
> the dying kernel, etc..)

New kernel image being corrupted problem can be solved up to great extent
by write protecting that memory location.

So those who are happy with RS-232, they don't have to configure kdump.
Just connect serial console and get the oops message out.

Thanks
Vivek 
