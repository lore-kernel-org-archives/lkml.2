Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2ITLS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:18:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62898 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2ITLSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:18:24 -0400
Date: Thu, 20 Sep 2012 12:18:15 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
Message-ID: <20120920111815.GC2117@linaro.org>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1348135563.11116.94.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348135563.11116.94.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:06:03AM +0100, Pawel Moll wrote:
> Morning,
> 
> On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> > +/dts-v1/;
> > +
> > +/include/ "skeleton.dtsi"
> 
> Any particular reason to include skeleton? And I think it would be
> better to use #address-cells = <2> and #size-cells = <2>, to be ready
> for LPAE addresses...
> 
> > +/ {
> > +	model = "XENVM-4.2";
> > +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> > +	interrupt-parent = <&gic>;
> > +
> > +	chosen {
> > +		bootargs = "earlyprintk console=hvc0 root=/dev/xvda init=/sbin/init";
> > +	};

Are you sure this default command line is appropriate?

I don't normally like to see default command lines unless they really
add something which is crucial for the board to work.

None of those args looks vital to me.  They are configuration choices
and should be left up to the user.

Cheers
---Dave
