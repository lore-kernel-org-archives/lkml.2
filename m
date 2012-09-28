Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2I1RQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:16:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53500 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab2I1RP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:15:59 -0400
Date: Fri, 28 Sep 2012 18:15:53 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>, Rob Landley <rob@landley.net>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 RESEND 2/2] ARM: local timers: add timer support using
 IO mapped register
Message-ID: <20120928171549.GA29991@e102568-lin.cambridge.arm.com>
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
 <1347694914-1457-2-git-send-email-rvaswani@codeaurora.org>
 <5062013F.8050507@codeaurora.org>
 <20120928122858.GD9472@e106331-lin.cambridge.arm.com>
 <20120928155746.GB2253@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20120928155746.GB2253@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Sep 2012 17:15:56.0986 (UTC) FILETIME=[EC6121A0:01CD9D9C]
X-MC-Unique: 112092818155702001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 04:57:46PM +0100, Dave Martin wrote:
> [ Note: please aim to CC devicetree-discuss@lists.ozlabs.org with any
> patches or bindings relevant to device tree. ]
> 
> [ Lorenzo, there's a question for you further down this mail. ]

[...]

> > > > +  If using the memory mapped interface, list the interrupts for each core,
> > > > +  starting with core 0.
> > 
> > I take it that core 0 means physical cpu 0 (i.e. MPIDR.Aff{2,1,0} == 0)?
> 
> Lorenzo, should we have a standard way of referring to CPUs and topology
> nodes documented as part of the topology bindings?  We certainly need
> rules of some kind, since when the topology is non-trivial there is no
> well-defined "first" CPU, nor any single correct order in which to list
> CPUs.

I think, and that's just my opinion, that whatever solution we go for to
describe the topology must contain the information needed by all kernel
subsystems to retrieve HW information. I do not think we should document
how devices connect to CPU(s)/Cluster(s) in the topology bindings per-se,
since those are properties that belong to device nodes.

There must be a common way for all devices to link to the topology, though.

The topology must be descriptive enough to cater for all required cases
and that's what Mark with PMU and all of us are trying to come up with, a solid
way to represent with DT the topology of current and future ARM systems.

First idea I implemented and related LAK posting:

http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080873.html

Are "cluster" nodes really needed or "cpu" nodes are enough ? I do not
know, let's get this discussion started, that's all I need.

But definitely declaring IRQs in physical CPU id order (and mind, as you say,
physical CPU ids, ie MPIDR, can be sparsely populated) and initializing them
*thinking* the order is the logical one is plainly broken.

> The topology may also be sparsely populated (e.g.,
> Aff[2,1,0] in { (0,0,0), (0,0,1), (0,1,0), (0,1,1), (0,1,2), (0,1,3) })
> 
> It would be bad if different driver bindings end up solving this in
> different ways (even non-broken ways)

Yes, I agree and code that relies on any temporary work-around to tackle
this problem should not be merged before we set in stone proper topology
bindings.

Lorenzo

