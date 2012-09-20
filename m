Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2ITMQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:16:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17824 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2ITMP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:15:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14655142"
Date: Thu, 20 Sep 2012 13:15:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Pawel Moll <pawel.moll@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
In-Reply-To: <1348142133.11116.109.camel@hornet>
Message-ID: <alpine.DEB.2.02.1209201308490.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>  <1348135563.11116.94.camel@hornet>  <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com> <1348142133.11116.109.camel@hornet>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Pawel Moll wrote:
> On Thu, 2012-09-20 at 12:39 +0100, Stefano Stabellini wrote:
> > There are no peripherals apart from the ones that are already described
> > here (timer, gic). All the peripherals that the guest sees are virtual
> > devices that show up on xenbus (a virtual bus). In order to initialize
> > xenbus, the guest only needs the hypervisor node.  So I'll remove the
> > ranges and interrupt-map.
> 
> So all the peripherals are actually discoverable - awesome!
> 
> But the fact is that the only "vexpressness" of this tree is
> memory@80000000 and gic@2c001000. The rest (not much of it ;-) is a
> "generic A15 platform". 
> 
> I understand that you had to use some "compatible" value to get
> initialization code and I'm flattered ;-) by your choice of
> "arm,vexpress", but maybe - as suggested by others - you would be better
> off with generating this stuff in runtime, by whatever tool is used to
> instantiate the guest?

Yes, it is certainly going to be generated at run time. Does it make
sense to keep an example under arch/arm/boot/dts? I think so. There must
be other platforms that actually pass the device tree to the kernel from
the firmware and still have a dts in the kernel tree, right?
If actually there are none, it is probably best to forget about this
patch :)

Regarding the choice of "arm,vexpress", there was a discussion at kernel
summit about vexpress being the right choice as a base platform for
virtual machines on ARM, even though in the Xen case it means having a
vexpress with no peripherals.
