Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2ITL5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:57:23 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:42930 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2ITL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:57:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14654536"
Date: Thu, 20 Sep 2012 12:56:30 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
In-Reply-To: <1348136222.26501.19.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1209201240110.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com> <1348136222.26501.19.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Ian Campbell wrote:
> On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> > +/include/ "skeleton.dtsi"
> > +
> > +/ {
> > +	model = "XENVM-4.2";
> 
> Why the shouty caps?

It looks like that model names are always capital, at least in the
vexpress family.


> Did you mean 4.3 here and throughout?

Nope, after all this is the fruit of the work we did on Xen 4.2, mostly
already upstream. By the time of the 4.3 release we might have a
different dts.


> > +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> 
> Is this second compatible thing actually true? We don't actually emulate
> much (anything?) of what would be on a real vexpress motherboard.
> 
> "arm,vexpress" is used only in v2m.c and I don't think we want the
> majority of that -- we don't provide any of the peripherals which it
> registers.
> 
> I think the only things we might want out of that lot are the arch timer
> and perhaps the uart0 (as a debug port).
> 
> I suspect we should have our own xen machine .c.
> 
> [...]

It is true that we are "arm,vexpress" compatible at the moment.
Also we need to be unless we want to introduce our own arch/arm/mach-xen
that I think is overkill.

Versatile Express is flexible enough to be a good base for our own
virtual machine platform, especially if the maintainers keep an eye on
getting everything through DT and not expecting devices just to be there
;-)


> > +	gic: interrupt-controller@2c001000 {
> > +		compatible = "arm,cortex-a9-gic";
> 
> Don't we mean "arm,cortex-a15-gic" here? That's what we actually
> provide. I'm not sure how the a9 and a15 differ.

The GIC that comes with vexpress is a9 compatible.
