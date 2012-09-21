Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2IULSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 07:18:11 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:5979 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab2IULSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:18:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,462,1344211200"; 
   d="scan'208";a="14687716"
Date: Fri, 21 Sep 2012 12:17:15 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Dave Martin <dave.martin@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
In-Reply-To: <20120920212948.GF27312@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209211214520.29232@kaball.uk.xensource.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com> <1348135563.11116.94.camel@hornet> <20120920111815.GC2117@linaro.org> <20120920212948.GF27312@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Sep 20, 2012 at 12:18:15PM +0100, Dave Martin wrote:
> > On Thu, Sep 20, 2012 at 11:06:03AM +0100, Pawel Moll wrote:
> > > Morning,
> > > 
> > > On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> > > > +/dts-v1/;
> > > > +
> > > > +/include/ "skeleton.dtsi"
> > > 
> > > Any particular reason to include skeleton? And I think it would be
> > > better to use #address-cells = <2> and #size-cells = <2>, to be ready
> > > for LPAE addresses...
> > > 
> > > > +/ {
> > > > +	model = "XENVM-4.2";
> > > > +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> > > > +	interrupt-parent = <&gic>;
> > > > +
> > > > +	chosen {
> > > > +		bootargs = "earlyprintk console=hvc0 root=/dev/xvda init=/sbin/init";
> 
> earlyprintk=xen ?
> 

earlyprintk is not "selectable" on ARM (that would be a nice addition
though). It just goes to the configured uart, that is the only piece of
hardware that is being emulated by Xen at the moment.

In any case I have removed anything debug related, including
earlyprintk, from the default bootargs.
