Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2JBNov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:44:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41777 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2JBNot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:44:49 -0400
Date: Tue, 2 Oct 2012 14:44:44 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>, Rob Landley <rob@landley.net>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 RESEND 2/2] ARM: local timers: add timer support using
 IO mapped register
Message-ID: <20121002134444.GB28600@e102568-lin.cambridge.arm.com>
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
 <1347694914-1457-2-git-send-email-rvaswani@codeaurora.org>
 <5062013F.8050507@codeaurora.org>
 <20120928122858.GD9472@e106331-lin.cambridge.arm.com>
 <20120928155746.GB2253@linaro.org>
 <20120928171549.GA29991@e102568-lin.cambridge.arm.com>
 <20121002112704.GA2410@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20121002112704.GA2410@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 02 Oct 2012 13:44:45.0371 (UTC) FILETIME=[152920B0:01CDA0A4]
X-MC-Unique: 112100214444801601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:27:04PM +0100, Dave Martin wrote:
> On Fri, Sep 28, 2012 at 06:15:53PM +0100, Lorenzo Pieralisi wrote:
> > On Fri, Sep 28, 2012 at 04:57:46PM +0100, Dave Martin wrote:

[...]

> > There must be a common way for all devices to link to the topology, though.
> > 
> > The topology must be descriptive enough to cater for all required cases
> > and that's what Mark with PMU and all of us are trying to come up with, a solid
> > way to represent with DT the topology of current and future ARM systems.
> > 
> > First idea I implemented and related LAK posting:
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080873.html
> > 
> > Are "cluster" nodes really needed or "cpu" nodes are enough ? I do not
> > know, let's get this discussion started, that's all I need.
> 
> One thing which now occurs to me on this point it that if we want to describe
> the CCI properly in the DT (yes) then we need a way to describe the mapping
> between clusters and CCI slave ports.  Currently that knowledge just has to
> be a hard-coded hack somewhere: it's not probeable at all.

That's definitely a good point. We can still define CCI ports as belonging
to a range of CPUs, but that's a bit of a stretch IMHO.

> I'm not sure how we do that, or how we describe the cache topology, without
> the clusters being explicit in the DT
> 
> ...unless you already have ideas ?

Either we define the cluster node explicitly or we can always see it as a
collection of CPUs, ie phandles to "cpu" nodes. That's what the decision
we have to make is all about. I think that describing it explicitly make
sense, but we need to check all possible use cases to see if that's
worthwhile.

Lorenzo

