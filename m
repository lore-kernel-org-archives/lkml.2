Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2ITMku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:40:50 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:29165 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2ITMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:40:49 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14655854"
Date: Thu, 20 Sep 2012 13:39:58 +0100
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
In-Reply-To: <1348143533.26501.28.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1209201333460.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>  <1348136222.26501.19.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1209201240110.29232@kaball.uk.xensource.com> <1348143533.26501.28.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Ian Campbell wrote:
> > Versatile Express is flexible enough to be a good base for our own
> > virtual machine platform, especially if the maintainers keep an eye on
> > getting everything through DT and not expecting devices just to be there
> > ;-)
> 
> Perhaps what we want is a stricter subset of the stuff in mach-vexpress
> then. But if so then this should be expressed both in the DT and in the
> code, not just papered over by declaring things compatible when they are
> not.

But it is already expressed in the DT, by removing all the device nodes
we don't emulated. And it is already expressed in the code, by fully
discovering peripherals via DT, therefore not trying to initialize
non-present devices.


> > > > +	gic: interrupt-controller@2c001000 {
> > > > +		compatible = "arm,cortex-a9-gic";
> > > 
> > > Don't we mean "arm,cortex-a15-gic" here? That's what we actually
> > > provide. I'm not sure how the a9 and a15 differ.
> > 
> > The GIC that comes with vexpress is a9 compatible.
> 
> The GIC which Xen emulates is the one which matters here though, and
> that is an a15.

The a15 gic is still a9 compatible. OK to be precise I am going to add
"arm,cortex-a15-gic", but I cannot really remove "arm,cortex-a9-gic".
