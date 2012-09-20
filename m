Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab2ITMS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:18:58 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:7147 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2ITMSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:18:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14655251"
Message-ID: <1348143533.26501.28.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 20 Sep 2012 13:18:53 +0100
In-Reply-To: <alpine.DEB.2.02.1209201240110.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1348136222.26501.19.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1209201240110.29232@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 12:56 +0100, Stefano Stabellini wrote:
> On Thu, 20 Sep 2012, Ian Campbell wrote:
> > On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> > > +/include/ "skeleton.dtsi"
> > > +
> > > +/ {
> > > +	model = "XENVM-4.2";
> > 
> > Why the shouty caps?
> 
> It looks like that model names are always capital, at least in the
> vexpress family.
> 
> 
> > Did you mean 4.3 here and throughout?
> 
> Nope, after all this is the fruit of the work we did on Xen 4.2, mostly
> already upstream. By the time of the 4.3 release we might have a
> different dts.
> 
> 
> > > +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> > 
> > Is this second compatible thing actually true? We don't actually emulate
> > much (anything?) of what would be on a real vexpress motherboard.
> > 
> > "arm,vexpress" is used only in v2m.c and I don't think we want the
> > majority of that -- we don't provide any of the peripherals which it
> > registers.
> > 
> > I think the only things we might want out of that lot are the arch timer
> > and perhaps the uart0 (as a debug port).
> > 
> > I suspect we should have our own xen machine .c.
> > 
> > [...]
> 
> It is true that we are "arm,vexpress" compatible at the moment.

But we aren't, we don't emulate 90%+ of the actual hardware which
vexpress compatibility would actually imply.

Look in arch/arm/mach-vexpress/v2m.c, which is the only thing keyed off
this compat value -- it's full of stuff which we don't (and aren't going
to) implement.

> Also we need to be unless we want to introduce our own arch/arm/mach-xen
> that I think is overkill.

Probably.

> Versatile Express is flexible enough to be a good base for our own
> virtual machine platform, especially if the maintainers keep an eye on
> getting everything through DT and not expecting devices just to be there
> ;-)

Perhaps what we want is a stricter subset of the stuff in mach-vexpress
then. But if so then this should be expressed both in the DT and in the
code, not just papered over by declaring things compatible when they are
not.

> > > +	gic: interrupt-controller@2c001000 {
> > > +		compatible = "arm,cortex-a9-gic";
> > 
> > Don't we mean "arm,cortex-a15-gic" here? That's what we actually
> > provide. I'm not sure how the a9 and a15 differ.
> 
> The GIC that comes with vexpress is a9 compatible.

The GIC which Xen emulates is the one which matters here though, and
that is an a15.

Ian.

